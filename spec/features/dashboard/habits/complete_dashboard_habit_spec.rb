require 'rails_helper'

RSpec.feature "CompleteDashboardHabits", type: :feature do
  given(:user) { create(:user) }
  given(:category) { create(:category, user: user) }
  given!(:goal) { create(:goal, user: user, category: category) }
  given(:habit) { create(:habit, user: user, goal: goal) }

  feature 'Complete Habit' do

    scenario 'Authenticated user try to complete Habit' do
      log_in(user)

      visit dashboard_path
      visit complete_dashboard_habit_path(habit)

      expect(page).to have_content 'Habit has been successfully completed.'
      expect(page).to have_current_path(dashboard_path)
    end
  end
end
