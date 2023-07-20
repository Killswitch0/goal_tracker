class CreateUserGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :user_groups do |t|
      t.boolean :confirm, default: false

      t.references :user, null: false, foreign_key: true
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end

    add_index :user_groups, %i[ user_id group_id ], unique: true
  end
end
