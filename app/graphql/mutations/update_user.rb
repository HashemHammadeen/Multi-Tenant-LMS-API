module Mutations
  class UpdateUser < BaseMutation
    argument :id, ID, required: true
    argument :name, String, required: false
    argument :email, String, required: false

    field :user, Types::UserType, null: true
    field :errors, [String], null: false

    def resolve(id:, **args)
      user_to_update = User.find(id) # Scoped by default_scope


      raise "Unauthorized" unless context[:current_ability].can?(:update, user_to_update)

      if user_to_update.update(args.compact)
        { user: user_to_update, errors: [] }
      else
        { user: nil, errors: user_to_update.errors.full_messages }
      end
    end
  end
end