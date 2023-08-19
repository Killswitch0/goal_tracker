class ApplicationController < ActionController::Base
  include SessionsHelper
  include Sorting

  before_action :set_notifications, if: :current_user

  private

  def set_notifications
    notifications = Notification.where(recipient: current_user).newest_first.limit(9)
    @unread = notifications.unread
    @read = notifications.read
  end

  def redirect_user
    redirect_to home_path unless current_user
  end

  def redirect_back
    redirect_to root_path if current_user
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."

      redirect_to login_url
    end
  end

  def date_today
    Time.now.localtime.to_date
  end
end
