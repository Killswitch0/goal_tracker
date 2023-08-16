class AddCompleteDateToTask < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :complete_date, :date
  end
end
