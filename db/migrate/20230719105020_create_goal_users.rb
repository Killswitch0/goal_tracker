class CreateGoalUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :goal_users do |t|
      t.boolean :confirm, default: false

      t.references :user, null: false, foreign_key: true
      t.references :goal, null: false, foreign_key: true

      t.timestamps
    end

    add_index :goal_users, %i[ user_id goal_id ], unique: true
  end
end
