require 'rails_helper'

RSpec.feature "AddGoals" do
  given(:user) { create :user }
  given(:challenge) { create :challenge, user: user }
  given!(:challenge_user) { create :challenge_user, challenge: challenge, user: user, confirm: true }
  given!(:goal) { create :goal, user: user }

  feature 'Add Goal to Challenge', %q{
    In order users may share own progress
    to each other in challenge,
    wee need to be able to add Goal to Challenge.
  } do

    scenario 'Authenticated user try to add Goal to Challenge' do
      log_in(user)

      visit add_goal_challenge_path(challenge)

      select goal.name, from: 'Goal'
      click_on 'Create'

      expect(page).to have_content 'Goal successfully added to the challenge.'
    end
  end
end
