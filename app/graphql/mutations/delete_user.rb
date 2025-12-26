module Mutations
  class DeleteUser < BaseMutation
    # We only need the ID to find the user
    argument :id, ID, required: true

    # Return fields
    field :success, Boolean, null: false
    field :errors, [ String ], null: false

    def resolve(id:)
      # 1. Find the user (default_scope ensures school isolation)
      user_to_delete = User.find(id)

      # 2. Authorization Check (CanCanCan)
      # This checks if the current_user's role is 'admin' (defined in Ability.rb)
      raise "Unauthorized" unless context[:current_ability].can?(:destroy, user_to_delete)

      # 3. Prevent Self-Deletion (Safety Logic)
      if user_to_delete.id == context[:current_user].id
        return { success: false, errors: [ "You cannot delete your own admin account." ] }
      end

      # 4. Perform Delete
      if user_to_delete.destroy
        { success: true, errors: [] }
      else
        { success: false, errors: user_to_delete.errors.full_messages }
      end
    rescue ActiveRecord::RecordNotFound
      { success: false, errors: [ "User not found in your school." ] }
    rescue => e
      { success: false, errors: [ e.message ] }
    end
  end
end