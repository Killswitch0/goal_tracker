class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[show]
  before_action :user, only: :update

  helper_method :user

  def show; end

  def new
    @user = User.new
  end

  def edit; end

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

  def update
    if @user.update(user_params)
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

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
      :old_password
    )
  end
end
