module Mutations
  class UpdateCourse < BaseMutation
    argument :id, ID, required: true
    argument :title, String, required: false
    argument :description, String, required: false

    field :course, Types::CourseType, null: true
    field :errors, [String], null: false

    def resolve(id:, **attributes)
      course = Course.find(id) # default_scope ensures they don't find other school's courses

      # 1. Authorization Check
      raise "Unauthorized" unless context[:current_ability].can?(:update, course)

      if course.update(attributes)
        { course: course, errors: [] }
      else
        { course: nil, errors: course.errors.full_messages }
      end
    end
  end
end