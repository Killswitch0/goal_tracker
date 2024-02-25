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
    end
  end
end
