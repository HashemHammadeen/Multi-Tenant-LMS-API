module Mutations
  class CreateCourse < BaseMutation
    argument :title, String, required: true
    argument :description, String, required: false

    field :course, Types::CourseType, null: true
    field :errors, [String], null: false

    def resolve(title:, description: nil)

      # 1. Authorization Check
      puts context[:current_user]
      raise "Unauthorized" unless context[:current_ability].can?(:create, Course)

      # 2. Logic (Pinned to Current.school via Phase 3 Scoping)
      course = Course.new(title: title, description: description, school: context[:current_school])

      if course.save
        { course: course, errors: [] }
      else
        { course: nil, errors: course.errors.full_messages }
      end
    end
  end
end