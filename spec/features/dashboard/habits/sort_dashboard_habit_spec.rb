require 'rails_helper'

RSpec.feature "SortDashboardHabits" do
  given(:user) { create(:user) }
  given(:category) { create(:category, user: user) }
  given!(:goal) { create(:goal, user: user, category: category) }

  given!(:habit1) { create(:habit, user: user, goal: goal, name: 'My string 1') }
  given!(:habit2) { create(:habit, user: user, goal: goal, name: 'My string 2') }
  given!(:habit3) { create(:habit, user: user, goal: goal, name: 'My string 3') }
  given!(:habit4) { create(:habit, user: user, goal: goal, name: 'My string 4') }
  given!(:completion_date) { create :completion_date, habit: habit1, date: Date.today }

  feature 'Filter Habits' do

    before do
      log_in(user)

      # create(:completion_date, habit: habit1, date: Date.today)
    end

    scenario 'User try to show uncompleted and completed Habits' do
      visit dashboard_path(all_habits: 'all')

      expect(page).to have_content(habit1.name)
      expect(page).to have_content(habit2.name)
      expect(page).to have_content(habit3.name)
      expect(page).to have_content(habit4.name)
    end

    scenario 'User try to show only uncompleted Habits' do
      visit dashboard_path(open_habits: 'open')

      expect(page).not_to have_content(habit1.name)
      expect(page).to have_content(habit2.name)
      expect(page).to have_content(habit3.name)
      expect(page).to have_content(habit4.name)
    end
  end
end
