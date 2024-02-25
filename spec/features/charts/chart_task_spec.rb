require 'rails_helper'

RSpec.feature "ChartTasks", type: :feature do
  let(:user) { create(:user) }

  before do
    log_in(user)

    visit task_chart_path(period: 'day')
  end

  feature 'User use Task chart', '
    In order to see my progress on chart
    i want to use all chart functional
  ' do
      scenario 'User visit to Task chart' do
        expect(page).to have_content 'TASKS CHART'
        expect(find('.chart-for-dropdown')).to have_content('Tasks')
        expect(page).to have_css('a.day-link', class: 'active')
      end
    end
end
