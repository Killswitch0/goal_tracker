class ApplicationController < ActionController::Base
  include SessionsHelper

  private

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

  def sort_column
    Task.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def date_today
    Time.now.localtime.to_date
  end
end
