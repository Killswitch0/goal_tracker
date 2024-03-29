require 'rails_helper'

RSpec.feature 'CreateDashboardTasks' do
  given(:user) { create(:user) }
  given(:category) { create(:category, user:) }
  given!(:goal) { create(:goal, user:, category:) }
  given(:task) { create(:task, user:, goal:) }

  feature 'Create Task', '
    In order to see completed/uncompleted tasks,
    manage them, wee need to be able to create Task
  ' do
    scenario 'Authenticated user try to create Task' do
      log_in(user)

      visit new_dashboard_task_path

      fill_in 'Name', with: task.name

      select goal.name, from: 'task_goal_id'

      select task.deadline.year, from: 'task_deadline_1i'
      select task.deadline.strftime('%B'), from: 'task_deadline_2i'
      select task.deadline.day.to_s, from: 'task_deadline_3i'

      click_on 'Create'

      expect(page).to have_content I18n.t('tasks.create.success')
      expect(page).to have_content(task.name)
      expect(page).to have_current_path(dashboard_path)
    end
  end
end
