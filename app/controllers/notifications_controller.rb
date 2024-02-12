class NotificationsController < ApplicationController
  def index
    @all_count = @notifications.count
    @read_count = @read.count
    @unread_count = @unread.count

    if params[:filter] == 'all'
      @notifications
    elsif params[:filter] == 'read'
      @notifications = @read
    elsif params[:filter] == 'unread'
      @notifications = @unread  
    end
  end
end
