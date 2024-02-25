require 'rails_helper'

RSpec.feature 'FilterGoalsInChallenges' do
  given(:user) { create :user }
  given(:user2) { create :user }

  given!(:goal1) { create :goal, user: }
  given!(:goal2) { create :goal, user: user2, name: 'Buy home', color: 'red' }
  given!(:goal3) { create :goal, user: user2, name: 'Buy lambo', color: 'green' }

  given(:challenge) { create :challenge, user: }
  given(:challenge_user) { create :challenge_user, challenge:, user:, confirm: true }
  given(:challenge_user2) { create :challenge_user, challenge:, user: user2, confirm: true }
  given!(:challenge_goal) do
    create :challenge_goal, challenge:, challenge_user:, goal: goal1, user:
  end
  given!(:challenge_goal2) do
    create :challenge_goal, challenge:, challenge_user: challenge_user2, goal: goal2, user: user2
  end

  feature 'Filter goals', '
    In order to see my goals
    i want to be able filter them
  ' do
    scenario 'Authenticated user try to show his goals' do
      log_in(user)

      visit challenge_path(challenge.id, filter: user.id)

      expect(page).to have_content(user.name)

      expect(page).not_to have_css('li.goal-items__item', text: user2.name.to_s)
    end

    scenario 'Authenticated user try to show all goals' do
      log_in(user)

      visit challenge_path(challenge)

      expect(page).to have_content(user.name)
      expect(page).to have_content(user2.name)
    end
  end
end
