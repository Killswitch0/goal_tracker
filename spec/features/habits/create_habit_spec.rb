require 'rails_helper'

RSpec.feature 'CreateHabits' do
  given(:user) { create(:user) }
  given(:category) { create(:category, user:) }
  given(:goal) { create(:goal, user:, category:) }
  given(:habit) { create(:habit, user:, goal:) }

  feature 'Create Habit', '
    In order to see habits,
    wich belongs to Goal,
    complete them
    and see habits in calendar
    wee need to be able to create Habit
  ' do
    scenario 'Authenticated user try to create Habit and complete' do
      log_in(user)

      ### create ###
      visit new_goal_habit_path(goal)

      fill_in 'Name', with: 'Make 7 push ups'
      fill_in 'Description', with: habit.description

      click_on 'Create'

      expect(page).to have_content I18n.t('habits.create.success')
      expect(page).to have_content(habit.name)
      expect(page).to have_content(habit.description)

      ### complete ###
      visit complete_goal_habit_path(goal, habit)
      expect(page).to have_content I18n.t('habits.complete.completed')
    end

    scenario 'Non-authenticated user try to create Habit' do
      visit new_goal_habit_path(goal)

      expect(current_path).to eq home_path
    end
  end
end
