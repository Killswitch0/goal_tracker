class AddCategoryRefToGoals < ActiveRecord::Migration[7.0]
  def change
    add_reference :goals, :category, null: false, foreign_key: true
  end
end
