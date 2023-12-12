class PasswordResetsController < ApplicationController
  # POST /password_resets
  #----------------------------------------------------------------------------
  def create
    user = User.find_by_email(params[:email])

    if user
      user.send_password_reset
      flash[:noticed] = t('.success')
      redirect_to home_path
    else
      flash[:noticed] = t('.fail')
      redirect_to new_password_reset_path
    end
  end

  # GET /password_resets/1/edit
  #----------------------------------------------------------------------------
  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end

  # PUT /password_resets/1
  #----------------------------------------------------------------------------
  def update
    @user = User.find_by_password_reset_token(params[:id])

    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to password_reset_path, flash[:danger] = t('.fail')
    elsif @user.update(user_params)
      flash[:noticed] = t('.success')
      redirect_to login_path
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :password,
      :password_confirmation
    ).merge(
      admin_edit: true
    )
  end
end
