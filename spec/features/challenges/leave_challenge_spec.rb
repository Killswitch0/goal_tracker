require 'rails_helper'

RSpec.feature "LeaveChallenges" do
  given(:user) { create :user }
  given(:challenge) { create :challenge, user: user }
  given!(:challenge_user) { create :challenge_user, user: user, challenge: challenge }

  before { log_in(user) }

  feature 'Leave challenges' do

    context '/challenges/:id' do
      scenario 'Authenticated user try to leave challenges' do
        visit challenge_path(challenge)
        find('[@id="challenges-show"]/div[1]/div[3]/div[2]/button').click
        find("[@id='exampleModal#{challenge.id}']/div/div/div[3]/a").click

        expect(page).to have_content I18n.t('challenges.leave.success')
      end
    end

    context '/challenges' do
      scenario 'Auth user try to leave challenges' do
        visit challenges_path

        click_on 'Leave'
        find("[@id='exampleModalLeave#{challenge.id}']/div/div/div[3]/a").click

        expect(page).to have_content I18n.t('challenges.leave.success')
      end
    end
  end
end
