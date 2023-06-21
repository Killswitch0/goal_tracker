class AddColorToGoals < ActiveRecord::Migration[7.0]
  def change
    add_column :goals, :color, :string
  end
end
