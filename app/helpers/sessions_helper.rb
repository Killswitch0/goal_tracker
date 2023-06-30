module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def remember(user)
    user.remember_me
    cookies.encrypted.permanent[:remember_token] = user.remember_token
    cookies.encrypted.permanent[:user_id] = user.id
  end

  def forget(user)
    user&.forget_me
    cookies.delete :user_id
    cookies.delete :remember_token
  end

  def current_user
    if session[:user_id].present?
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    elsif cookies.encrypted[:user_id].present?
      user = User.find_by(id: cookies.encrypted[:user_id])
      if user&.remember_token_authenticated?(cookies.encrypted[:remember_token])
        log_in user
        @current_user ||= user
      end
    end
  end

  def user_signed_in?
    current_user.present?
  end

  def logged_in?
    !current_user.nil?
  end

  def require_no_authentication
    return if !user_signed_in?

    flash[:danger] = "You are already signed in."
    redirect_to root_url
  end

  def log_out
    forget current_user
    session.delete(:user_id)
    @current_user = nil
  end

  def current_user?(user)
    user == current_user
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  def hold_email
    params[:session][:email] if params[:session]
  end
end
