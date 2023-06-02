class SessionsController < ApplicationController
  layout "application", except: %i[ new ]

  def new
    redirect_to login_path if current_user
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    if user && user.authenticate(params[:session][:password])
      if user.email_confirmed
        log_in user
        flash[:noticed] = "#{current_user.name}, welcome to the app!"
        redirect_back_or user
      else
        flash.now[:danger] = 'Please activate your account by following the
        instructions in the account confirmation email you received to proceed'
        render :new
      end
    else
      flash[:danger] = "Invalid email/password combination"
      redirect_to login_path
    end
  end

  #
  # def create
  #   user = User.find_by(email: params[:session][:email].downcase)
  #
  #   if user && user.authenticate(params[:session][:password])
  #     log_in user
  #     flash[:noticed] = "#{current_user.name}, welcome to the app!"
  #     redirect_back_or user
  #   else
  #     flash[:danger] = "Invalid email/password combination"
  #     redirect_to login_path
  #   end
  # end

  def destroy
    log_out
    redirect_to home_path
  end
end
