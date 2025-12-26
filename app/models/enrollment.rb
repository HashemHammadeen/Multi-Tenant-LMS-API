class Enrollment < ApplicationRecord
  # belongs to requires the record to be existed
  belongs_to :school
  belongs_to :user
  belongs_to :course

  # The value of user_id must be unique for each combination of course_id AND school_id
  # why we added the school_id here even it is handled in the default_scope?
  # default_scope limit what rows you can see
  # but validates manage duplicates, that means no same user id and same course will
  # be enrolled twice because we have school id also
  # defaul-->reading   validates-->writing
  validates :user_id, uniqueness: { scope: [:course_id, :school_id], message: "already enrolled in this course" }

  default_scope { where(school_id: Current.school&.id) }
end
