class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[show]
  before_action :user, only: %i[update delete_image_attachment]

  helper_method :user

  # GET /users/new
  #----------------------------------------------------------------------------
  def new
    @user = User.new
  end

  # GET /users/1
  #----------------------------------------------------------------------------
  def show; end

  # GET /users/1/edit
  #----------------------------------------------------------------------------
  def edit; end

  # POST /signup
  #----------------------------------------------------------------------------
  def create
    @user = User.new(user_params)

    if @user.save
      UserMailer.registration_confirmation(@user).deliver
      flash[:noticed] = t('.success')
      redirect_to login_path
    else
      flash[:danger] = t('.fail')
      render :new, status: :unprocessable_entity
    end
  end

  # PUT /users/1
  #----------------------------------------------------------------------------
  def update
    if @user.update(user_params)
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # GET /users/:id/confirm_email
  #----------------------------------------------------------------------------
  def confirm_email
    user = User.find_by_confirm_token(params[:id])

    if user
      user.email_activate
      flash[:noticed] = t('.success')
      redirect_to login_path
    else
      flash[:danger] = t('.fail')
      redirect_to home_path
    end
  end

  # DELETE /users/1/delete_image_attachment
  #----------------------------------------------------------------------------
  def delete_image_attachment
    @user.avatar.purge
    redirect_to edit_user_path(@user)
  end

  private

  def user
    @user ||= User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation,
      :old_password,
      :avatar
    )
  end
end
