module Mutations
  class SignIn < BaseMutation
    # These are the inputs the user sends in Postman
    argument :email, String, required: true
    argument :password, String, required: true

    # These are the fields the user gets back
    field :user, Types::UserType, null: true
    field :token, String, null: true
    field :errors, [String], null: false

    def resolve(email:, password:)
      # Call your optimized service
      result = AuthenticationService.sign_in(email: email, password: password)

      {
        user: result[:user],
        token: result[:token],
        errors: []
      }
    rescue => e
      { user: nil, token: nil, errors: [e.message] }
    end
  end
end