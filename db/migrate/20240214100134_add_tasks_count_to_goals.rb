class AddTasksCountToGoals < ActiveRecord::Migration[7.0]
  def change
    add_column :goals, :tasks_count, :integer, default: 0
  end
end
