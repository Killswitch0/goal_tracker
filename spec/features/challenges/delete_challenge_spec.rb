require 'rails_helper'

RSpec.feature 'DeleteChallenges' do
  given(:user) { create :user }
  given(:challenge) { create :challenge, user: }
  given!(:challenge_user) { create :challenge_user, user:, challenge: }

  feature 'Delete challenges', '
    In order to manipulate my challenges
    i want to be able delete them.
  ' do
    scenario 'Authenticated user try to delete Challenge' do
      log_in(user)

      visit challenges_path

      find("#destroy-challenge_#{challenge.id}").click
      find('#confirmButton').click

      expect(page).to have_content I18n.t('challenges.destroy.success')
    end
  end
end
