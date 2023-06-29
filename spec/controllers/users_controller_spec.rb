require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { attributes_for(:user) }

  describe 'GET #new' do
    before { get :new }

    it 'assigns a new User to @user' do
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'GET #edit' do
    let(:user) { create(:user) }
    before { get :edit, params: { id: user } }

    it 'assigns the requested user to @user' do
      expect(assigns(:user)).to eq(user)
    end

    it 'renders an edit view' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #create' do

    context 'with valid attributes' do
      it 'saves the new user to the database' do
        expect { post :create, params: { user: user } }
          .to change(User, :count).by(1)
      end

      it 'sends a registration confirmation email' do
        expect { post :create, params: { user: user } }
          .to change(ActionMailer::Base.deliveries, :count).by(1)
      end

      it 'sets a flash notice message' do
        post :create, params: { user: user }
        expect(flash[:noticed]).to eq "Please confirm your email address to continue"
      end

      it 'redirects to the login page' do
        post :create, params: { user: user }
        expect(response).to redirect_to(login_path)
      end
    end

    context 'with invalid attributes' do
      let(:invalid_params) { attributes_for(:user, email: nil) }

      it 'does not create new user' do
        expect { post :create, params: { user: invalid_params } }
          .to_not change(User, :count)
      end

      it 'sets a flash danger message' do
        post :create, params: { user: invalid_params }
        expect(flash[:danger]).to eq "Something go wrong..."
      end

      it 'renders the new template with unprocessable_entity status' do
        post :create, params: { user: invalid_params }
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH #update' do
    let(:user) { create(:user) }

    context 'valid attributes' do
      it 'assigns the requested user to @user' do
        patch :update, params: { id: user, user: attributes_for(:user) }
        expect(assigns(:user)).to eq(user)
      end

      it 'changes user attributes' do
        patch :update, params: { id: user, user: { name: 'Max', email: 'newemail@mail.com', old_password: '111111' } }
        user.reload

        expect(user.name).to eq 'Max'
        expect(user.email).to eq 'newemail@mail.com'
      end
    end
  end
end
