require 'rails_helper'

RSpec.feature "ViewGoals" do
  given(:user) { create(:user) }
  given(:category) { create(:category, user: user) }

  let!(:goal1) { create(:goal, user: user, category: category, name: "Name 1") }
  let!(:goal2) { create(:goal, user: user, category: category, name: "Name 2") }
  let!(:goal3) { create(:goal, user: user, category: category, name: "Name 3") }

  feature 'View goal', '%q{
    In order to visit to the Goal
    i need to be able to choose it
  }' do
    scenario 'Authenticated user try to view Goal' do
      log_in(user)

      visit goals_path

      click_on goal1.name

      expect(current_path).to eq goal_path(goal1)
      expect(page).to have_content 'Name 1'
    end
  end
end