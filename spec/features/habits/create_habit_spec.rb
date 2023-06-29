require 'rails_helper'

RSpec.feature "CreateHabits", type: :feature do
  given(:user) { create(:user) }
  given(:category) { create(:category, user: user) }
  given(:goal) { create(:goal, user: user, category: category) }
  given(:habit) { create(:habit, user: user, goal: goal) }

  feature 'Create Habit', '%q{
    In order to see habits,
    wich belongs to Goal,
    complete them
    and see habits in calendar
    wee need to be able to create Habit
  }' do

    scenario 'Authenticated user try to create Habit and complete' do
      log_in(user)

      ### create ###
      visit new_goal_habit_path(goal)

      fill_in 'Name', with: habit.name
      fill_in 'Description', with: habit.description

      click_on 'Create'

      expect(current_path).to eq category_goal_path(category, goal)
      expect(page).to have_content(habit.name)
      expect(page).to have_content(habit.description)

      ### complete ###
      visit complete_habit_path(habit)
      expect(page).to have_content("Your habit successfully completed.")
    end

    scenario 'Non-authenticated user try to create Habit' do
      visit new_goal_habit_path(goal)

      expect(current_path).to eq home_path
    end

  end
end
