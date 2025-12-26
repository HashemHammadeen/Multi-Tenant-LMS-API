# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World"
      end
      field :sign_in, mutation: Mutations::SignIn
      field :sign_up, mutation: Mutations::SignUp
      field :sign_out, mutation: Mutations::SignOut

      field :create_course, mutation: Mutations::CreateCourse
      field :update_course, mutation: Mutations::UpdateCourse
      field :delete_course, mutation: Mutations::DeleteCourse

      field :create_user, mutation: Mutations::CreateUser
      field :update_user, mutation: Mutations::UpdateUser
      field :delete_user, mutation: Mutations::DeleteUser

      field :create_enrollment, mutation: Mutations::CreateEnrollment
      field :delete_enrollment, mutation: Mutations::DeleteEnrollment
    end
end
