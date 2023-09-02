require 'rails_helper'

RSpec.feature "CreateDashboardHabits" do
  given(:user) { create(:user) }
  given(:category) { create(:category, user: user) }
  given!(:goal) { create(:goal, user: user, category: category) }
  given(:habit) { create(:habit, user: user, goal: goal) }

  feature 'Create Habit', '%q{
    In order to see habits,
    wich belongs to Goal,
    complete them
    and see habits in calendar
    wee need to be able to create Habit
  }' do

    scenario 'Authenticated user try to create Habit' do
      log_in(user)

      visit new_dashboard_habit_path

      fill_in 'Name', with: 'Do 10 squats in morning'
      fill_in 'Description', with: habit.description

      select goal.name, from: 'habit_goal_id'

      click_on 'Add Habit'

      expect(page).to have_content 'Habit created successfully.'

    end
  end
end
