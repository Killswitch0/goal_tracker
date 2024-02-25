module ControllerHelper
  def log_in(user)
    user = User.where(email: user.email).first if user.is_a?(Symbol)
    session[:user_id] = user.id
  end
end
