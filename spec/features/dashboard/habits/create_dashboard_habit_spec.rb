require 'rails_helper'

RSpec.feature 'CreateDashboardHabits' do
  given(:user) { create(:user) }
  given(:category) { create(:category, user:) }
  given!(:goal) { create(:goal, user:, category:) }
  given(:habit) { create(:habit, user:, goal:) }

  feature 'Create Habit', '
    In order to see habits,
    which belongs to Goal,
    complete them
    and see habits in calendar
    wee need to be able to create Habit
  ' do
    scenario 'Authenticated user try to create Habit' do
      log_in(user)

      visit new_dashboard_habit_path

      fill_in 'Name', with: 'Do 10 squats in morning'
      fill_in 'Description', with: habit.description

      select goal.name, from: 'habit_goal_id'

      click_on 'Create'

      expect(page).to have_content I18n.t('habits.create.success')
    end
  end
end
