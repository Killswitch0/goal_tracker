require 'rails_helper'

RSpec.feature 'DeleteGoalFromChallenges' do
  given(:user) { create :user }

  given(:goal) { create :goal, user: }

  given(:challenge) { create :challenge, user: }
  given(:challenge_user) { create :challenge_user, challenge:, user: }
  given!(:challenge_goal) do
    create :challenge_goal, challenge:, challenge_user:, goal:, user:
  end

  describe 'Delete goal' do
    scenario 'Authenticated user try to delete goal from Challenge' do
      log_in(user)

      visit challenge_path(challenge)
      expect(page).to have_css('[@id="challenges-show"]/div[2]/ul/li', text: user.name)

      find('[@id="challenges-show"]/div[2]/ul/li/a').click
      find("[@id='confirmButton']").click

      expect(page).not_to have_css('[@id="challenges-show"]/div[2]/ul/li/div[2]', text: user.name)
    end
  end
end
