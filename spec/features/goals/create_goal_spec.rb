require 'rails_helper'

RSpec.feature "CreateGoals" do
  given(:user) { create(:user) }
  given!(:category) { create(:category, user: user) }
  given!(:goal) { create(:goal, user: user, category: category) }

  feature 'Create goal', %q{
    In order to create habits, tasks
    wich belongs to Goal
    wee need be able to create Goal
  } do

    scenario 'Authenticated user try to create, complete and delete Goal' do
      log_in(user)

      ### create ###
      visit new_goal_path

      fill_in 'Name', with: 'Buy the best protein in store!'
      fill_in 'Description', with: goal.description
      select category.name, from: 'Category'
      select goal.color, from: 'Color'
      select goal.deadline.year, from: 'goal_deadline_1i'
      select goal.deadline.strftime('%B'), from: 'goal_deadline_2i'
      select goal.deadline.day.to_s, from: 'goal_deadline_3i'

      click_button 'Create'

      expect(page).to have_content I18n.t('goals.create.success')

      ### delete ###
      visit goal_path(goal)

      find("[@id='goal_#{goal.id}']").click
      find('[@id="confirmButton"]').click

      expect(page).to have_content I18n.t('goals.destroy.success')

      expect(page).not_to have_content(goal.name)
      expect(page).not_to have_content(goal.description)
      expect(page).not_to have_content(goal.deadline)
      expect(page).not_to have_content(goal.complete)
    end

    scenario 'Non-authenticated user try to create Goal' do
      visit new_goal_path

      expect(current_path).to eq home_path
    end
  end
end
