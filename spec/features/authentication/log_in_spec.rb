require 'rails_helper'

RSpec.feature 'LogIns' do
  given(:user) { create(:user) }

  feature 'User log in', '
    In order to be able to use
    application as an User
    i want to be able log in
  ' do
    scenario 'Registred user try to log in' do
      visit login_path

      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'

      expect(current_path).to eq user_path(user)
      expect(page).to have_content "Welcome, #{user.name}"
    end

    scenario 'Non-registred user try to log in' do
      visit login_path

      fill_in 'Email', with: 'email@email.com'
      fill_in 'Password', with: '123123'
      click_on 'Log in'

      expect(current_path).to eq login_path
      expect(page).to have_content I18n.t('sessions.create.fail')
    end
  end
end
