require 'rails_helper'

RSpec.feature "CreateTasks" do
  given(:user) { create(:user) }
  given(:category) { create(:category, user: user) }
  given(:goal) { create(:goal, user: user, category: category) }
  given(:task) { create(:task, user: user, goal: goal) }

  feature 'Create Task and complete', '%q{
    In order to see completed/uncompleted tasks,
    manage them, wee need to be able to create Task
  }' do

    scenario 'Authenticated user try to create Task and complete' do
      log_in(user)

      ### create ###
      visit category_goal_path(category, goal)
      visit new_goal_task_path(goal)

      fill_in 'Name', with: task.name
      check 'Complete'

      deadline = DateTime.now

      select deadline.year.to_s, from: 'task_deadline_1i'
      select deadline.strftime('%B'), from: 'task_deadline_2i'
      select deadline.day.to_s, from: 'task_deadline_3i'
      select deadline.hour.to_s, from: 'task_deadline_4i'
      select '07', from: 'task_deadline_5i'


      click_on 'Add Task'

      expect(current_path).to eq category_goal_path(category, goal)
      expect(page).to have_content(task.name)


      ### complete ###
      visit complete_task_path(task)
      expect(page).to have_content 'Task has been successfully completed.'
    end

    scenario 'Non-authenticated user try to create Task' do
      visit new_goal_task_path(goal)

      expect(current_path).to eq home_path
    end

  end
end
