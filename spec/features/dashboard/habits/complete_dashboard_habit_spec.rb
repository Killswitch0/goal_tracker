require 'rails_helper'

RSpec.feature 'CompleteDashboardHabits', type: :feature do
  given(:user) { create(:user) }
  given(:category) { create(:category, user:) }
  given(:goal) { create(:goal, user:, category:) }
  given(:habit) { create(:habit, user:, goal:) }

  feature 'Complete Habit' do
    scenario 'Authenticated user try to complete Habit' do
      log_in(user)

      visit dashboard_path
      visit complete_dashboard_habit_path(habit)

      expect(page).to have_content I18n.t('habits.complete.completed')
      expect(page).to have_current_path(dashboard_path)
    end
  end
end
