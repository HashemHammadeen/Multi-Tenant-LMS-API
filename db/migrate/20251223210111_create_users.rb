class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.references :school, null: false, foreign_key: true

      ## Devise fields
      t.string :email,              null: false
      t.string :encrypted_password, null: false

      ## Domain fields
      t.string  :name,   null: false
      t.integer :role,   null: false, default: 0
      t.boolean :active, default: true

      t.timestamps
    end
    # How it works: It creates a "Composite Index."
    # Instead of checking just the email
    # the database checks the combination of school_id + email.
    # the email could be used for two different schools because
    add_index :users, [ :school_id, :email ], unique: true
  end
end
