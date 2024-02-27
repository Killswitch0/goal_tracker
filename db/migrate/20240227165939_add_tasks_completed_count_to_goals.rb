class AddTasksCompletedCountToGoals < ActiveRecord::Migration[7.0]
  def self.up
    add_column :goals, :tasks_completed_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :goals, :tasks_completed_count
  end
end
