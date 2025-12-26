module Mutations
  class SignOut < BaseMutation
    field :message, String, null: false
    field :errors, [String], null: false

    def resolve
      # 1. Grab the token from the request headers
      # Note: We use context[:request] because we updated the controller context
      auth_header = context[:request].headers['Authorization']
      token = auth_header&.split(' ')&.last
      if token.blank?
        # This 'return' is VALID because it is inside 'def resolve'
        return { message: "", errors: ["No token found in headers"] }
      end

      # 2. Basic segment check to prevent the "segments" error
      if token.count('.') != 2
        return { message: "", errors: ["Invalid JWT format"] }
      end

      # 3. Call your service
      AuthenticationService.sign_out(token: token)

      { message: "Successfully logged out", errors: [] }
    rescue => e
      { message: "", errors: [e.message] }
    end
  end
end