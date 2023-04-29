class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.boolean :complete, default: 0
      t.references :goal, null: false, foreign_key: true

      t.timestamps
    end
  end
end
