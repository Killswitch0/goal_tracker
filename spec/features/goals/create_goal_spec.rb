require 'rails_helper'

RSpec.feature "CreateGoals" do
  given(:user) { create(:user) }
  given(:category) { create(:category, user: user) }
  given(:goal) { create(:goal, user: user, category: category) }

  feature 'Create goal', '%q{
    In order to create habits, tasks
    wich belongs to Goal
    wee need be able to create Goal
  }' do

    scenario 'Authenticated user try to create, complete and delete Goal' do
      log_in(user)

      ### create ###
      visit new_category_goal_path(category)

      fill_in 'Name', with: goal.name
      fill_in 'Description', with: goal.description
      select category.name, from: 'Category'
      select goal.color, from: 'Color'
      fill_in 'Deadline', with: goal.deadline

      click_button 'Create'

      expect(current_path).to eq goals_path

      ### delete ###
      visit category_goal_path(category, goal)

      click_on 'Destroy goal'

      expect(page).to have_content 'Goal was successfully destroyed.'

      expect(page).not_to have_content(goal.name)
      expect(page).not_to have_content(goal.description)
      expect(page).not_to have_content(goal.deadline)
      expect(page).not_to have_content(goal.complete)
    end

    scenario 'Non-authenticated user try to create Goal' do
      visit new_category_goal_path(category)

      expect(current_path).to eq home_path
    end
  end
end
