require 'rails_helper'

RSpec.feature "LogOuts" do
  given(:user) { create(:user) }

  feature 'User log out', '%q{
    In order to change account, exit from
    current session,
    i want to be able to log out
  }' do

    scenario 'Authenticated user try to log out' do
      log_in(user)

      visit logout_path

      expect(current_path).to eq login_path
      expect(page).to have_content 'Goodbye.'
    end

    scenario 'Non-authenticated user try to log out' do
      visit logout_path

      expect(current_path).to eq login_path
    end

  end
end
