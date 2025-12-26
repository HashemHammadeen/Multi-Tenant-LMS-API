module Mutations
  class SignUp < BaseMutation
    # These are the inputs the user sends in Postman

    argument :name, String, required: true
    argument :email, String, required: true
    argument :password, String, required: true
    argument :role, String, required: false # Defaults to 'user' in the service
    # These are the fields the user gets back


    # In GraphQL, every object returned by a query or mutation must have a corresponding "Type".
    field :user, Types::UserType, null: true
    field :token, String, null: true
    field :errors, [ String ], null: false

    def resolve(**args)
      result = AuthenticationService.sign_up(**args)

      {
        user: result[:user],
        token: result[:token],
        errors: []
      }
    rescue => e
      { user: nil, token: nil, errors: [ e.message ] }
    end
  end
end