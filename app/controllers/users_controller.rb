class UsersController < ApplicationController
  layout "home", only: %i[ new create edit ]

  before_action :set_user, only: %i[ show edit update ]
  before_action :logged_in_user, only: %i[ show ]

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    if @user.save
      UserMailer.registration_confirmation(@user).deliver
      flash[:noticed] = "Please confirm your email address to continue"
      redirect_to root_url
    else
      flash[:danger] = "Something go wrong..."
      render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to @user
    else
      render :edit
    end
  end

  def confirm_email
    user = User.find_by_confirm_token(params[:id])

    if user
      user.email_activate
      flash[:noticed] = "Welcome to the Sample App! Your email has been confirmed. Please sign in to continue."
      redirect_to user_path(user)
    else
      flash[:danger] = "Sorry. User does not exist"
      redirect_to home_path
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
