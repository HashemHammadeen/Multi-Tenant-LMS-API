class User < ApplicationRecord
  devise :database_authenticatable,# Enables email + password login
         :validatable,
         :jwt_authenticatable,    # Enables stateless JWT auth (no cookies/sessions)
         jwt_revocation_strategy: JwtDenylist  # Enables logout

  belongs_to :school

  has_many :enrollments, dependent: :destroy
  has_many :enrolled_courses, through: :enrollments, source: :course

  enum :role, { user: 0, instructor: 1, admin: 2 }

  validates :email, presence: true, uniqueness: { scope: :school_id }, format: { with: URI::MailTo::EMAIL_REGEXP }

  # we skipp the validation here if the password exist
  # because the user can update his data so we do not ask for his password again
  validates :password, length: { minimum: 8 }, if: -> { password.present? }
  validates :role, inclusion: { in: roles.keys }

  # this is important it makes each query specified to the specific school
  default_scope { where(school_id: Current.school&.id) }
end
