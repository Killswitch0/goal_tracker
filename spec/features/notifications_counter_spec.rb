require 'rails_helper'

RSpec.feature "NotificationsCounters" do
  given(:user) { create :user }
  given(:user2) { create :user }
  given(:challenge) { create :challenge, user: }
  given!(:challenge_user) { create :challenge_user, challenge:, user: user2 }

  feature 'Increases notifications counter with getting' do
    scenario 'User recieve notification alert' do
      log_in(user2)

      find('[@id="navbar__right"]/li[2]/a').click
      expect(page).to have_css('#notifications-count', text: '1')
      expect(page).to have_css('#notifications-count-header', text: '1')
    end
  end
end
