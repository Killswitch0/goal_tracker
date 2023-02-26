class AddDeadlineToGoals < ActiveRecord::Migration[7.0]
  def change
    add_column :goals, :deadline, :datetime
  end
end
