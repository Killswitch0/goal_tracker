class CreateGoals < ActiveRecord::Migration[7.0]
  def change
    create_table :goals do |t|
      t.string :name
      t.string :description
      t.integer :days_completed, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
