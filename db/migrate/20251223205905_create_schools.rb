class CreateSchools < ActiveRecord::Migration[8.1]
  def change
    create_table :schools do |t|
      t.string :name, null: false
      t.string :subdomain, null: false
      t.boolean :active, default: true

      t.timestamps
    end
    # this line is [Database Constraint]
    # Enforces one school per subdomain
    # Prevents race conditions at DB level
    add_index :schools, :subdomain, unique: true
  end
end
