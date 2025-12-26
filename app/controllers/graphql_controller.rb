# frozen_string_literal: true

class GraphqlController < ApplicationController
  # Remove this line - it doesn't exist in ActionController::API
  # skip_before_action :verify_authenticity_token

  before_action :authenticate_user_from_token!,unless: :public_operation?
  def public_operation?
    # 1. Define the list FIRST
    public_list = %w[signIn signUp]

    # 2. Capture the operation name and query string
    operation_name = params[:operationName]
    query_string = params[:query].to_s

    # 3. Check if it's public (return a Boolean)
    # We check the query string as a fallback in case Postman doesn't send operationName
    public_list.include?(operation_name) ||
      public_list.any? { |op| query_string.include?(op) }
  end
  def execute
    puts "CURRENT USER: #{current_user.inspect}"

    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]

    context = {
      current_user: current_user,
      current_school: Current.school,
      current_ability: Ability.new(current_user),
      request: request,
    }

    result = Task2Schema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?
    handle_error_in_development(e)
  end

  private

  def authenticate_user_from_token!
    token = request.headers['Authorization']&.split(' ')&.last
    return render json: { error: 'No token provided' }, status: :unauthorized unless token

    begin
      secret = Rails.application.credentials.devise_jwt_secret_key || Rails.application.secret_key_base
      decoded = JWT.decode(token, secret, true, { algorithm: 'HS256' })

      user_id = decoded[0]['sub']
      jti = decoded[0]['jti']

      # Check if token is revoked
      return render json: { error: 'Token revoked' }, status: :unauthorized if JwtDenylist.exists?(jti: jti)

      # Use unscoped to bypass default_scope that filters by school_id
      @current_user = User.unscoped.find_by(id: user_id)

      return render json: { error: 'User not found' }, status: :unauthorized unless @current_user

      # CRITICAL: Verify user belongs to the subdomain's school
      if @current_user.school_id != Current.school&.id
        return render json: { error: 'User does not belong to this school' }, status: :forbidden
      end

    rescue JWT::DecodeError => e
      Rails.logger.error("JWT Decode Error: #{e.message}")
      render json: { error: 'Invalid token' }, status: :unauthorized
    rescue StandardError => e
      Rails.logger.error("Authentication Error: #{e.message}")
      render json: { error: 'Authentication failed' }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end

  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { errors: [{ message: e.message, backtrace: e.backtrace }], data: {} }, status: 500
  end
end