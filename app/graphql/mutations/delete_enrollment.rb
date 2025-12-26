module Mutations
  class DeleteEnrollment < BaseMutation
    argument :id, ID, required: true

    field :success, Boolean, null: false

    def resolve(id:)
      enrollment = Enrollment.find(id)
      raise "Unauthorized" unless context[:current_ability].can?(:destroy, enrollment)

      { success: enrollment.destroy }
    end
  end
end