class RemoveCompletedFromHabits < ActiveRecord::Migration[7.0]
  def change
    remove_column :habits, :completed, :boolean
  end
end
