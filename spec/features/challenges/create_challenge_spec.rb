require 'rails_helper'

RSpec.feature "CreateChallenges" do
  given(:user) { create :user }
  given(:challenge) { create :challenge, user: user }
  given(:challenge_user) { create :challenge_user, challenge: challenge, user: user }


  feature 'Create challenges', %q{
    In order to invite users to challenges,
    confirm invite, add goals to challenges
    we need to be able to create Challenge.
  } do

    scenario 'Authenticated user try to create Challenge' do
      log_in(user)

      visit new_challenge_path

      fill_in 'Name', with: challenge.name
      fill_in 'Description', with: challenge.description

      fill_in 'Deadline', with: challenge.deadline

      click_button 'Create'

      expect(page).to have_content I18n.t('challenges.create.success')
      expect(page).to have_content challenge.name
    end
  end
end
