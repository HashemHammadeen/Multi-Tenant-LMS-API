# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [ Types::NodeType, null: true ], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ ID ], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World!"
    end

    #===================================
    # --- USER QUERIES ---

    # null: true: This is critical for authentication. If a user is not
    # logged in, the API should return null rather than crashing.
    field :current_user, Types::UserType, null: true do
      description "Returns the currently logged-in user profile"
    end

    def current_user
      context[:current_user]
    end

    # null--> because I always return smth maybe the list is empty
    # but still not null
    field :users, [ Types::UserType ], null: false do
      description "List users (Admins see all, Users see self)"
    end

    def users
      # .accessible_by filters the list based on Ability.rb rules
      User.accessible_by(context[:current_ability])
    end

    field :usernull, Types::UserType, null: true do
      argument :id, ID, required: true
    end

    def usernull(id:)
      user_record = User.find(id)
      # Manually check ability for a single record
      context[:current_ability].authorize!(:read, user_record)
      user_record
    rescue CanCan::AccessDenied, ActiveRecord::RecordNotFound
      nil
    end

    # --- COURSE QUERIES ---

    field :courses, [ Types::CourseType ], null: false

    def courses
      # Anyone authenticated can see courses (per your requirements)
      Course.accessible_by(context[:current_ability])
    end

    field :course, Types::CourseType, null: true do
      argument :id, ID, required: true
    end

    def course(id:)
      course_record = Course.find(id)
      context[:current_ability].authorize!(:read, course_record)
      course_record
    rescue CanCan::AccessDenied, ActiveRecord::RecordNotFound
      nil
    end

    # --- ENROLLMENT QUERIES ---

    field :enrollments, [ Types::EnrollmentType ], null: false

    def enrollments
      # Students will only see their own records here automatically!
      Enrollment.accessible_by(context[:current_ability])
    end

    field :enrollment, Types::EnrollmentType, null: true do
      argument :id, ID, required: true
    end

    def enrollment(id:)
      enroll_record = Enrollment.find(id)
      context[:current_ability].authorize!(:read, enroll_record)
      enroll_record
    rescue CanCan::AccessDenied, ActiveRecord::RecordNotFound
      nil
    end
  end
end
