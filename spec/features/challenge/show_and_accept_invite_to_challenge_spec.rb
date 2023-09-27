require 'rails_helper'

RSpec.feature "ShowAndAcceptInviteToChallenges" do
  given(:user) { create :user }
  given(:user2) { create :user }

  given(:challenge) { create :challenge, user: user }
  given!(:challenge_user2) { create :challenge_user, challenge: challenge, user: user2, confirm: false }

  feature 'Show invite', %q{
    In order to accept invite to Challenge
    we need to be able to see him
  } do

    before do
      log_in(user2)

      visit challenges_path
    end

    scenario 'Authenticated user try to see invite to Challenge' do
      find('[@id="challenges-index"]/div[1]/div/div[2]/button').click
      expect(page).to have_css('[@id="offcanvasExample"]/div[2]/div/table/tbody/tr', text: challenge.user.name)
    end

    scenario 'Authenticated user try to accept invite to Challenge' do
      find('[@id="offcanvasExample"]/div[2]/div/table/tbody/tr[2]/td/form/button', text: 'Accept').click
      expect(page).to have_content I18n.t('challenges.confirm_invitation.success', challenge_name: challenge.name)
    end

    scenario 'Authenticated user try to decline invite to Challenge' do
      find('[@id="offcanvasExample"]/div[2]/div/table/tbody/tr[2]/td/form/button', text: 'Decline').click
      expect(page).to have_content I18n.t('challenges.decline_invitation.success', challenge_name: challenge.name)
    end
  end
end