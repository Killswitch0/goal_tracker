require 'rails_helper'

RSpec.feature "SortDashboardTasks" do
  given(:user) { create(:user) }
  given(:category) { create(:category, user: user) }
  given!(:goal) { create(:goal, user: user, category: category) }

  given!(:task1) { create(:task, user: user, goal: goal, complete: true) }
  given!(:task2) { create(:task, user: user, goal: goal, complete: true) }
  given!(:task3) { create(:task, user: user, goal: goal, complete: false) }
  given!(:task4) { create(:task, user: user, goal: goal, complete: true) }

  feature 'Filter tasks' do

    before do
      log_in(user)
    end

    scenario 'User try to show uncompleted and completed Tasks' do
      visit dashboard_path(all_tasks: 'all')

      expect(page).to have_content(task1.name)
      expect(page).to have_content(task2.name)
      expect(page).to have_content(task3.name)
      expect(page).to have_content(task4.name)
    end

    scenario 'User try to show only uncompleted Tasks' do
      visit dashboard_path(open_tasks: 'open')

      expect(page).not_to have_content(task1.name)
      expect(page).not_to have_content(task2.name)
      expect(page).to have_content(task3.name)
      expect(page).not_to have_content(task4.name)
    end
  end
end
