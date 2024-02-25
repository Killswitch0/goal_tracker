require 'rails_helper'

RSpec.feature 'ChartHabits', type: :feature do
  given(:user) { create(:user) }
  given(:goal) { create(:goal, user:) }
  given!(:habit) { create(:habit, goal:, user:) }
  given(:completion_date) { create(:completion_date, habit:) }

  before do
    log_in(user)

    visit habit_chart_path(chart_type: 'line', period: 'day')
  end

  feature 'User use a chart', '
    In order to see
    my progress on chart
    i want to use all chart
    functional
  ' do
    scenario 'User visit to chart with Line type and day period' do
      expect(page).to have_content 'HABITS CHART'
      expect(find('.chart-for-dropdown')).to have_content 'Habits'
      expect(find('.chart-type-dropdown')).to have_content 'Line'
      expect(page).to have_css('a.day-link', class: 'active')
    end

    scenario 'User switch chart type to Column and period link to Week' do
      expect(page).to have_content 'HABITS CHART'

      find('.chart-type-dropdown').click
      click_link 'Column'
      click_link 'Week'

      expect(find('.chart-for-dropdown')).to have_content 'Habits'
      expect(find('.chart-type-dropdown')).to have_content 'Column'
      expect(page).to have_css('a.week-link', class: 'active')
    end

    scenario 'User switch period to Month' do
      expect(page).to have_content 'HABITS CHART'

      click_link 'Month'

      expect(find('.chart-for-dropdown')).to have_content 'Habits'
      expect(find('.chart-type-dropdown')).to have_content 'Line'
      expect(page).to have_css('a.month-link', class: 'active')
    end

    scenario 'User switch chart to Tasks' do
      find('.chart-for-dropdown').click
      click_link 'Show Tasks'

      expect(page).to have_content 'TASKS CHART'
      expect(find('.chart-for-dropdown')).to have_content 'Tasks'
    end
  end
end
