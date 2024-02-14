require 'rails_helper'

RSpec.feature 'CompleteDashboardTasks' do
  given(:user) { create(:user) }
  given(:category) { create(:category, user:) }
  given(:goal) { create(:goal, user:, category:) }
  given(:task) { create(:task, user:, goal:) }

  feature 'Complete Task' do
    scenario 'Authenticated user try to complete Task' do
      log_in(user)

      visit dashboard_path
      visit complete_dashboard_task_path(task)

      expect(page).to have_content I18n.t('tasks.complete.completed')
      expect(page).to have_current_path(dashboard_path)
    end
  end
end
