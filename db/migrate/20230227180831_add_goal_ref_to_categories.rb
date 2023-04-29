class AddGoalRefToCategories < ActiveRecord::Migration[7.0]
  def change
    add_reference :categories, :goal, null: true, foreign_key: true
  end
end
