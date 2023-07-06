require 'rails_helper'

RSpec.feature "UserCompleteGoals" do
  given(:user) { create(:user) }
  given(:category) { create(:category, user: user) }
  given(:goal) { create(:goal, user: user, category: category) }

  feature 'Complete goal', '%q{
    In order to finish my goal
    i need to be able update
    status to complete
  }' do

    scenario 'Authenticated user try to complete Goal' do
      log_in(user)

      ### complete ###
      visit category_goal_path(category, goal)
      check 'Complete'
      click_on 'Complete goal'

      expect(current_path).to eq category_goal_path(category, goal)
      expect(page).to have_checked_field('goal_complete')
    end

  end
end
