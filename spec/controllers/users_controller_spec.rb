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

    before do
      get :edit, params: { id: user }
      controller.instance_variable_set(:@user, user)
    end

    it 'assigns the requested user to @user' do
      expect(assigns(:user)).to eq(user)
    end

    it 'makes the user method available in the view' do
      expect(controller.view_assigns['user']).to eq(user)
    end

    it 'renders an edit view' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new user to the database' do
        expect { post :create, params: { user: } }
          .to change(User, :count).by(1)
      end

      it 'sends a registration confirmation email' do
        expect { post :create, params: { user: } }
          .to change(ActionMailer::Base.deliveries, :count).by(1)
      end

      it 'sets a flash notice message' do
        post :create, params: { user: }
        expect(flash[:noticed]).to eq 'Please confirm your email address to continue'
      end

      it 'redirects to the login page' do
        post :create, params: { user: }
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
        expect(flash[:danger]).to eq 'Something went wrong...'
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

    before { controller.instance_variable_set(:@user, user) }

    context 'valid attributes' do
      it 'assigns the requested user to @user' do
        patch :update, params: { id: user, user: attributes_for(:user) }
        expect(assigns(:user)).to eq(user)
      end

      it 'makes the user method available in the view' do
        expect(controller.view_assigns['user']).to eq(user)
      end

      it 'changes user attributes' do
        patch :update, params: { id: user, user: { name: 'Max', email: 'newemail@mail.com', old_password: '111111' } }

        expect(user.name).to eq 'Max'
        expect(user.email).to eq 'newemail@mail.com'
      end
    end
  end
end
