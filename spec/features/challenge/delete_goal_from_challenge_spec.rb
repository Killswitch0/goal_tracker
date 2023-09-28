require 'rails_helper'

RSpec.feature "DeleteGoalFromChallenges" do
  given(:user) { create :user }

  given(:goal) { create :goal, user: user }

  given(:challenge) { create :challenge, user: user }
  given(:challenge_user) { create :challenge_user, challenge: challenge, user: user }
  given!(:challenge_goal) { create :challenge_goal, challenge: challenge, challenge_user: challenge_user, goal: goal, user: user }

  describe 'Delete goal' do
    scenario 'Authenticated user try to delete goal from Challenge' do
      log_in(user)

      visit challenge_path(challenge)
      expect(page).to have_css('[@id="challenges-show"]/div[2]/ul/li', text: user.name)

      find('[@id="challenges-show"]/div[2]/ul/li/form/button').click

      expect(page).not_to have_css('[@id="challenges-show"]/div[2]/ul/li/div[2]', text: user.name)
    end
  end
end
