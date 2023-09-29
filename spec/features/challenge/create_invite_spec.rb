require 'rails_helper'

RSpec.feature "Create Invite to Challenge", type: :feature do
  given(:user) { create :user }
  given(:user2) { create :user }
  given(:challenge) { create :challenge, user: user }
  given!(:challenge_user) { create :challenge_user, challenge: challenge, user: user, confirm: true }

  feature 'Create invite to Challenge', %q{
    In order to invite users to Challenge
    and see them progress, wee need to be able
    send invite to Challenge
  } do
    scenario 'Authenticated user try to create Invite to Challenge' do
      log_in(user)

      visit create_invitation_challenge_path(challenge)

      fill_in 'Email', with: user2.email
      click_on 'Create'

      expect(page).to have_content "Invitation sent successfully to user #{user2.email}."
    end
  end
end
