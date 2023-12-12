require 'rails_helper'

RSpec.feature "SearchGoals" do
  given(:user) { create(:user) }
  given(:category) { create(:category, user: user) }

  let!(:goal1) { create(:goal, user: user, color: 'Purple', category: category, name: "Name 1") }
  let!(:goal2) { create(:goal, user: user, color: 'Pink', category: category, name: "Name 2") }
  let!(:goal3) { create(:goal, user: user, color: 'Gold', category: category, name: "Name 3") }

  feature 'Search Goal', %q{
    In order to use my goal
    i want to be able to search fast
  } do

    scenario 'Authenticated user try to search Goal' do
      log_in(user)

      visit goals_path

      find(:css, '[@id="search"]').set('2')
      find('[@id="goals-index"]/div/div[2]/div/div[1]/form/button').click

      expect(page).to have_content 'Name 2'

      expect(page).not_to have_content 'Name 1'
      expect(page).not_to have_content 'Name 3'
    end
  end
end
