require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  describe "GET #index" do
    let(:user) { create(:user) }
    it "returns http success" do
      log_in user
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    let(:group) { create(:group) }
    let(:user) { create(:user) }

    it "returns http success" do
      log_in user
      group.user_groups.create(user: user, confirm: true)
      get :show, params: { id: group, user_id: user }

      expect(current_user.name).to eq(user.name)

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #new" do
    let(:user) { create(:user) }
    it "returns http success" do
      log_in user
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #create" do
    let(:group) { create(:group) }
    let(:user) { create(:user) }
    it "returns http redirect" do
      log_in user
      expect { post :create, params: { group: { name: "New Group Name" } } }.to change(Group, :count).by(1)
      expect(response).to redirect_to group_path(Group.last)
      expect(response).to have_http_status(302)
    end
  end
end



