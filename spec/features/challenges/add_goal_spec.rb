require 'rails_helper'

RSpec.feature 'AddGoals' do
  given(:user) { create :user }
  given(:challenge) { create :challenge, user: }
  given!(:challenge_user) { create :challenge_user, challenge:, user:, confirm: true }
  given!(:goal) { create :goal, user: }

  feature 'Add Goal to Challenge', '
    In order users may share own progress
    to each other in challenges,
    wee need to be able to add Goal to Challenge.
  ' do
    scenario 'Authenticated user try to add Goal to Challenge' do
      log_in(user)

      visit add_goal_challenge_path(challenge)

      select goal.name, from: 'Goal'
      click_on 'Create'

      expect(page).to have_content I18n.t('challenges.add_goal.success')
    end
  end
end
