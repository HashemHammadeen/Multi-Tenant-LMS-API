module Mutations
  class CreateUser < BaseMutation
    argument :name, String, required: true
    argument :email, String, required: true
    argument :password, String, required: true
    argument :role, String, required: true

    field :user, Types::UserType, null: true
    field :errors, [ String ], null: false

    def resolve(**args)
      # CanCanCan Check
      raise "Unauthorized" unless context[:current_ability].can?(:create, User)

      # merge add the school id to the hash table
      user = User.new(args.merge(school: context[:current_school]))
      if user.save
        { user: user, errors: [] }
      else
        { user: nil, errors: user.errors.full_messages }
      end
    end
  end
end