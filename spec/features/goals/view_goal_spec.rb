require 'rails_helper'

RSpec.feature "ViewGoals" do
  given(:user) { create(:user) }
  given(:category) { create(:category, user: user) }

  let!(:goal1) { create(:goal, user: user, color: 'Purple', category: category, name: "Name 1") }
  let!(:goal2) { create(:goal, user: user, category: category, name: "Name 2") }
  let!(:goal3) { create(:goal, user: user, color: 'Gold', category: category, name: "Name 3") }

  feature 'View goal', %q{
    In order to visit to the Goal
    i need to be able to choose it
  } do
    scenario 'Authenticated user try to view Goal' do
      log_in(user)

      visit goals_path

      expect(page).to have_content 'Name 1'
      expect(page).to have_content 'Name 2'
      expect(page).to have_content 'Name 3'
    end
  end
end
