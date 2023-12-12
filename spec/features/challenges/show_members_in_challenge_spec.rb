require 'rails_helper'

RSpec.feature "ShowMembersInChallenges" do
  given(:user) { create :user }
  given(:user2) { create :user }

  given(:goal1) { create :goal, user: user }
  given(:goal2) { create :goal, user: user2, name: 'Buy home', color: 'red' }

  given(:challenge) { create :challenge, user: user }
  given!(:challenge_user) { create :challenge_user, challenge: challenge, user: user, confirm: true }
  given!(:challenge_user2) { create :challenge_user, challenge: challenge, user: user2, confirm: true }

  feature 'Members in Challenge', %q{
    In order to see members in Challenge
    i want to be able to show them
  } do

    scenario 'Authenticated user try to show members' do
      log_in(user)

      visit challenge_path(challenge)

      click_on 'Rating'

      expect(page).to have_css('[@id="offcanvasExample"]/div[2]/div/table/tbody/tr', text: user.name)
      expect(page).to have_css('[@id="offcanvasExample"]/div[2]/div/table/tbody/tr', text: goal1.tasks.count)

      expect(page).to have_css('[@id="offcanvasExample"]/div[2]/div/table/tbody/tr', text: user2.name)
      expect(page).to have_css('[@id="offcanvasExample"]/div[2]/div/table/tbody/tr', text: goal2.tasks.count)
    end

  end
end
