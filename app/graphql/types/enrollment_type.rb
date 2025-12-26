module Types
  class EnrollmentType < Types::BaseObject
    field :id, ID, null: false
    field :user, Types::UserType, null: false
    field :course, Types::CourseType, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end