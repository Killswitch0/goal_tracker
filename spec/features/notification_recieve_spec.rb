require 'rails_helper'

RSpec.feature "NotificationRecieves" do
  given(:user) { create :user }
  given(:user2) { create :user }
  given(:challenge) { create :challenge, user: }
  given!(:challenge_user) { create :challenge_user, challenge:, user: user2 }

  feature 'Notification recieve', '
    In oreder to see notifications
    wee need successfully get them
  ' do

    scenario 'User recieve notification' do
      log_in(user2)

      find('[@id="navbar__right"]/li[2]/a').click
      
      expect(page)
        .to have_css(
          "#notifications-list_#{user2.id}",
          text: "#{user.name} #{I18n.t('notifications.challenge.invited.parts.message')} #{challenge.name}"
        )
    end
  end
end
