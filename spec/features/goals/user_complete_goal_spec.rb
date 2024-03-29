require 'rails_helper'

RSpec.feature 'UserCompleteGoals' do
  given(:user) { create(:user) }
  given(:category) { create(:category, user:) }
  given(:goal) { create(:goal, user:, category:, name: 'Exercise regularly') }
  given!(:task) { create(:task, user:, goal:) }

  feature 'Complete goal', '
    In order to finish my goal
    i need to be able update
    status to complete
  ' do
    scenario 'Authenticated user try to complete Goal' do
      log_in(user)

      ### complete ###
      visit goal_path goal

      expect(page).to have_current_path goal_path goal

      find('.action').click
      expect(page).to have_content I18n.t('tasks.complete.completed')

      expect(current_path).to eq goal_path(goal)
      expect(page).to have_css('.goal-info > dl > dd.completed')
    end
  end
end
