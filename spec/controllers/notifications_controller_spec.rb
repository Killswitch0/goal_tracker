require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do
  describe '#index' do
    subject { get :index, params: { filter: :all } }

    let(:user) { create(:user) }

    before do
      log_in(user)
    end

    context 'user has no notifications' do
      it 'should show an empty list' do
        subject
        expect(response).to render_template(:index)

        expect(controller.instance_variable_get(:@notifications)).to be_empty
      end
    end

    context 'user has notifications' do
      let(:other_user) { create(:user) }
      let(:challenge) { create(:challenge, user: other_user) }

      it 'should show a list of notifications' do
        ChallengeUser.create!(user:, challenge:)

        subject
        expect(response).to render_template(:index)
        expect(controller.instance_variable_get(:@notifications)).to have_attributes(size: 1)
      end

      it 'should mark notifications as read' do
        ChallengeUser.create!(user:, challenge:)

        expect { subject }.to change { user.notifications.unread.count }.from(1).to(0)
      end
    end
  end
end
