require 'rails_helper'

RSpec.feature "CreateCategories" do
  given(:user) { create(:user) }
  given(:category) { create(:category) }

  feature 'Create Category', %q{
    In order to create goal
    as an authenticated user
    with category wee need to create
    category first
  } do

    scenario 'Authenticated user create a category' do
      log_in(user)

      visit new_category_path

      fill_in 'Name', with: 'IT'
      click_on 'Create'

      expect(current_path).to eq goals_path
    end

    scenario 'Non-authenticated user try to create a categiry' do
      visit new_category_path

      expect(current_path).to eq home_path
    end

  end
end
