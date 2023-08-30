require 'rails_helper'

RSpec.feature "CreateTasks" do
  given(:user) { create(:user) }
  given(:category) { create(:category, user: user) }
  given(:goal) { create(:goal, user: user, category: category) }
  given!(:task) { create(:task, user: user, name: 'My String', goal: goal) }

  feature 'Create Task and complete', '%q{
    In order to see completed/uncompleted tasks,
    manage them, wee need to be able to create Task
  }' do

    scenario 'Authenticated user try to create Task and complete' do
      log_in(user)

      ### create ###
      visit new_goal_task_path(goal)

      fill_in 'Name', with: task.name
      check 'Complete'

      select task.deadline.year, from: 'task_deadline_1i'
      select task.deadline.strftime('%B'), from: 'task_deadline_2i'
      select task.deadline.day.to_s, from: 'task_deadline_3i'
      select task.deadline.hour, from: 'task_deadline_4i'
      select task.deadline.min, from: 'task_deadline_5i'


      click_on 'Add Task'

      expect(page).to have_content "Task has been successfully created."
      expect(page).to have_content(task.name)


      ### complete ###
      visit complete_goal_task_path(goal, task)
      expect(page).to have_content 'Task has been successfully completed.'
    end

    scenario 'Non-authenticated user try to create Task' do
      visit new_goal_task_path(goal)

      expect(current_path).to eq home_path
    end

  end
end
