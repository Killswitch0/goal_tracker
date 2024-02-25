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
      expect(page).to have_css('li.goal-items__item', text: user.name)

      find('a.btn-close').click
      find('#confirmButton').click

      expect(page).not_to have_css('li.goal-items__item', text: user.name)
    end
  end
end
