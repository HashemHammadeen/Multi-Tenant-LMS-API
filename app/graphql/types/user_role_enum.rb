module Types
  class UserRoleEnum < Types::BaseEnum
    value "USER", value: "user"
    value "INSTRUCTOR", value: "instructor"
    value "ADMIN", value: "admin"
  end
end