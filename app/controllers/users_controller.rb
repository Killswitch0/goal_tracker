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
      log_in @user
      flash[:noticed] = "Welcome to the app!"
      redirect_to @user
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

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
