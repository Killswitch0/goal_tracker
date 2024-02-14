require 'rails_helper'

RSpec.feature 'SignUps' do
  given(:user) { create(:user) }

  feature 'User sign up', '
    In order to be able to use
    application as an User
    i want to be able sign up
  ' do
    scenario 'Non-registred user try to sign up' do
      visit signup_path
      fill_in 'Name', with: user.name
      fill_in 'Email', with: 'max@max.com'
      fill_in 'Password', with: user.password
      fill_in 'Confirmation', with: user.password
      click_on 'Sign up'

      expect(page).to have_content I18n.t('users.create.success')
      expect(current_path).to eq login_path
    end

    scenario 'Registred user try to sign up' do
      visit signup_path
      fill_in 'Name', with: "#{user.name}"
      fill_in 'Email', with: "#{user.email}"
      fill_in 'Password', with: "#{user.password}"
      fill_in 'Confirmation', with: "#{user.password}"
      click_on 'Sign up'

      expect(page).to have_content I18n.t('activerecord.errors.models.user.taken'), count: 1
      expect(current_path).to eq signup_path
    end
  end
end
