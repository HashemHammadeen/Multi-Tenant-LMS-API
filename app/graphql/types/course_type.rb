module Types
  class CourseType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :description, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    # Matching your model's associations
    field :enrollments, [Types::EnrollmentType], null: false
    field :enrolled_users, [Types::UserType], null: false
    field :school_id, Integer, null: false
    # Helpful for the UI: returns the count of students
    field :enrolled_count, Integer, null: false

    def enrolled_count
      object.enrollments.count
    end
  end
end