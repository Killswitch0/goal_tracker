class SessionsController < ApplicationController
  layout "application", except: %i[new]

  before_action :require_no_authentication, only: %i[new create]

  # GET /login
  #----------------------------------------------------------------------------
  def new; end

  # POST /login
  #----------------------------------------------------------------------------
  def create
    user = User.find_by(email: params[:session][:email].downcase)

    if user && user.authenticate(params[:session][:password])
      if user.email_confirmed
        log_in user
        remember(user) if params[:session][:remember_me] == '1'
        flash[:noticed] =  t('.success', user_name: current_user.name_or_email)
        redirect_back_or user
      else
        flash[:danger] = t('.activate')
        render :new, status: :unprocessable_entity
      end
    else
      flash[:danger] = t('.fail')
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /logout
  #----------------------------------------------------------------------------
  def destroy
    log_out
    flash[:noticed] = t('.success')
    redirect_to login_path
  end
end
