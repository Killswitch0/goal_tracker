require 'rails_helper'

RSpec.feature "UserCompleteGoals" do
  given(:user) { create(:user) }
  given(:category) { create(:category, user: user) }
  given(:goal) { create(:goal, user: user, category: category, name: 'Exercise regularly') }

  feature 'Complete goal', '%q{
    In order to finish my goal
    i need to be able update
    status to complete
  }' do

    scenario 'Authenticated user try to complete Goal' do
      log_in(user)
      GoalUser.create(goal: goal, user: user, confirm: true)

      ### complete ###
      visit goal_path goal

      expect(page).to have_current_path goal_path goal

      check 'Complete'
      click_on 'Complete'

      expect(current_path).to eq goal_path(goal)
      expect(page).to have_checked_field('goal_complete')
    end
  end
end

