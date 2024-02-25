require 'rails_helper'

RSpec.feature 'LeaveChallenges' do
  given(:user) { create :user }
  given(:challenge) { create :challenge, user: }
  given!(:challenge_user) { create :challenge_user, user:, challenge: }

  before { log_in(user) }

  feature 'Leave challenges' do
    context '/challenges/:id' do
      scenario 'Authenticated user try to leave challenges' do
        visit challenge_path(challenge)
        click_link 'Leave'

        find('#confirmButton').click

        expect(page).to have_content I18n.t('challenges.leave.success')
      end
    end

    context '/challenges' do
      scenario 'Auth user try to leave challenges' do
        visit challenges_path

        find("#leave-challenge_#{challenge.id}").click
        find('#confirmButton').click

        expect(page).to have_content I18n.t('challenges.leave.success')
      end
    end
  end
end
