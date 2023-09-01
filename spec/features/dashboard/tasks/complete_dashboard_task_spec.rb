require 'rails_helper'

RSpec.feature "CompleteDashboardTasks" do
  given(:user) { create(:user) }
  given(:category) { create(:category, user: user) }
  given(:goal) { create(:goal, user: user, category: category) }
  given(:task) { create(:task, user: user, goal: goal) }

  feature 'Complete Task' do

    scenario 'Authenticated user try to complete Task' do
      log_in(user)

      visit dashboard_path
      visit complete_dashboard_task_path(task)

      expect(page).to have_content 'Task has been successfully completed.'
      expect(page).to have_current_path(dashboard_path)
    end
  end
end
