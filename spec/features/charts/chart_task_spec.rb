require 'rails_helper'

RSpec.feature 'ChartTasks', type: :feature do # TODO: - add chart_goal_task spec
  let(:user) { create(:user) }

  before do
    log_in(user)

    visit task_chart_path(period: 'day')
    expect(page).to have_content 'TASKS CHART'
    expect(find('.chart-for-dropdown')).to have_content('Tasks')
  end

  feature 'User use Task chart', '
    In order to see my progress on chart
    i want to use all chart functional
  ' do
    scenario 'User visit to Task chart' do
      expect(page).to have_css('a.day-link', class: 'active')
    end

    scenario 'User switch chart period to Week' do
      click_link 'Week'
      expect(page).to have_css('a.week-link', class: 'active')
    end

    scenario 'User switch chart period to Month' do
      click_link 'Month'
      expect(page).to have_css('a.month-link', class: 'active')
    end
  end
end
