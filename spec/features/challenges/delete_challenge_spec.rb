require 'rails_helper'

RSpec.feature "DeleteChallenges" do
  given(:user) { create :user }
  given(:challenge) { create :challenge, user: user }
  given!(:challenge_user) { create :challenge_user, user: user, challenge: challenge }

  feature 'Delete challenges', %q{
    In order to manipulate my challenges
    i want to be able delete them.
  } do
    scenario 'Authenticated user try to delete Challenge' do
      log_in(user)

      visit challenges_path

      find("[@id='challenges-index']/div[1]/div/div/section/table/tbody/tr[1]/td[5]/button")
      find("[@id='exampleModalDelete#{challenge.id}']/div/div/div[3]/a").click

      expect(page).to have_content I18n.t('challenges.destroy.success')
    end
  end
end
