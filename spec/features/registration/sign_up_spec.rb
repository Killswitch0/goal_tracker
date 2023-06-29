require 'rails_helper'

RSpec.feature "SignUps", type: :feature do
  given(:user) { create(:user) }

  feature 'User sign up', %q{
    In order to be able to use
    application as an User
    i want to be able sign up
  } do

    scenario 'Non-registred user try to sign up' do
      visit signup_path
      fill_in 'Name', with: 'Max'
      fill_in 'Email', with: 'max@mail.com'
      fill_in 'Password', with: '111111'
      fill_in 'Confirmation', with: '111111'
      click_on 'Create account'

      expect(page).to have_content "Please confirm your email address to continue"
      expect(current_path).to eq login_path
    end

    scenario 'Registred user try to sign up' do
      visit signup_path
      fill_in 'Name', with: "#{user.name}"
      fill_in 'Email', with: "#{user.email}"
      fill_in 'Password', with: "#{user.password}"
      fill_in 'Confirmation', with: "#{user.password}"
      click_on 'Create account'

      expect(page).to have_content "Email has already been taken"
    end
  end
end
