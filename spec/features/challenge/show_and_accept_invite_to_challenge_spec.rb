require 'rails_helper'

RSpec.feature "ShowAndAcceptInviteToChallenges" do

  given!(:user) { create :user }
  given!(:user2) { create :user }

  given!(:goal1) { create :goal, user: user }
  given!(:goal2) { create :goal, user: user2, name: 'Buy home', color: 'red' }

  given!(:challenge) { create :challenge, user: user }
  given!(:challenge_user2) { create :challenge_user, challenge: challenge, user: user2, confirm: false }

  feature 'Show invite', %q{
    In order to accept invite to Challenge
    we need to be able to see him
  } do

    scenario 'Authenticated user try to see invite to Challenge' do
      log_in(user2)

      visit challenges_path

      find('[@id="challenges-index"]/div[1]/div/div[2]/button').click

      expect(page).to have_css('[@id="offcanvasExample"]/div[2]/div/table/tbody/tr', text: challenge.user.name)
    end
  end
end
