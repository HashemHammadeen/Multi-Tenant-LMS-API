class ApplicationController < ActionController::API
  # A before_action here will run before every request, automatically applying the tenant logic
  include ActionController::Cookies
  include Devise::Controllers::Helpers
   before_action :set_current_school
  def set_current_school
    # Extract subdomain
    subdomain = request.subdomain

    # Find the school by subdomain and active status
    school = School.find_by(subdomain: subdomain, active: true)

    # If not found, return error immediately
    if school.nil?
      render json: { error: "School not found or inactive" }, status: :not_found
      return
    end

    # Set Current.school for this request
    Current.school = school
  end
end
