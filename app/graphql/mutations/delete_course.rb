module Mutations
  class DeleteCourse < BaseMutation
    argument :id, ID, required: true

    field :success, Boolean, null: false
    field :errors, [String], null: false

    def resolve(id:)
      course = Course.find(id)

      # 1. Authorization Check
      raise "Unauthorized" unless context[:current_ability].can?(:destroy, course)

      if course.destroy
        { success: true, errors: [] }
      else
        { success: false, errors: course.errors.full_messages }
      end
    end
  end
end