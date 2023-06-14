class ChangeColumnNameForHabits < ActiveRecord::Migration[7.0]
  def change
    rename_column :habits, :keep, :completed
  end
end
