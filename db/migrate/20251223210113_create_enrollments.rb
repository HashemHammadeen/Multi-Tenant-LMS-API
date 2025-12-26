class CreateEnrollments < ActiveRecord::Migration[7.1]
  def change
    create_table :enrollments do |t|
      t.references :school, null: false, foreign_key: true
      t.references :user,   null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end
    # Without this line, a student could accidentally 
    # (or maliciously) enroll in the same course multiple times.
    add_index :enrollments, [ :school_id, :user_id, :course_id ], unique: true
  end
end
