class ApplicationController < ActionController::Base
  include SessionsHelper

  private

  def redirect_user
    redirect_to home_path unless current_user
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."

      redirect_to login_url
    end
  end
end
