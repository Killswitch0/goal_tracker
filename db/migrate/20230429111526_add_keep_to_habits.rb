class AddKeepToHabits < ActiveRecord::Migration[7.0]
  def change
    add_column :habits, :keep, :boolean, default: false
  end
end
