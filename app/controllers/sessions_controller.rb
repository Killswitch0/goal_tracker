class SessionsController < ApplicationController
  layout "application", except: %i[ new ]

  before_action :require_no_authentication, only: %i[ new create ]

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    if user && user.authenticate(params[:session][:password])
      if user.email_confirmed
        log_in user
        remember(user) if params[:session][:remember_me] == '1'
        flash[:noticed] = "#{current_user.name}, welcome to the app!"
        redirect_back_or user
      else
        flash[:danger] = 'Please activate your account by following the
        instructions in the account confirmation email you received to proceed.'
        render :new, status: :unprocessable_entity
      end
    else
      flash[:danger] = "Invalid email/password combination"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    flash[:noticed] = "See you later."
    redirect_to login_path
  end
end
