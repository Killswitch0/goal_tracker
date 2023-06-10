class CreateCompletionDates < ActiveRecord::Migration[7.0]
  def change
    create_table :completion_dates do |t|
      t.datetime :date
      t.references :habit, null: false, foreign_key: true

      t.timestamps
    end
  end
end
