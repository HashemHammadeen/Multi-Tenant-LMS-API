module Mutations
  class CreateEnrollment < BaseMutation
    argument :user_id, ID, required: true
    argument :course_id, ID, required: true

    field :enrollment, Types::EnrollmentType, null: true
    field :errors, [String], null: false

    def resolve(user_id:, course_id:)
      raise "Unauthorized" unless context[:current_ability].can?(:create, Enrollment)

      enrollment = Enrollment.new(
        user_id: user_id,
        course_id: course_id,
        school: context[:current_school]
      )

      if enrollment.save
        { enrollment: enrollment, errors: [] }
      else
        { enrollment: nil, errors: enrollment.errors.full_messages }
      end
    end
  end
end