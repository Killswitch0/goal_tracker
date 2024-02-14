class NotificationsController < ApplicationController
  TYPE_MAPPINGS = {
    'challenge_invite' => ChallengeUserNotification.name
  }.freeze

  def index
    @all_count = @notifications.count
    @read_count = @read.count
    @unread_count = @unread.count

    @type = TYPE_MAPPINGS[params[:filter]] || params[:filter]

    filter_notifications(params[:filter])
  end

  private

  def filter_notifications(filter)
    case filter
    when 'all'
      @notifications
    when 'read'
      @notifications = @read
    when 'unread'
      @notifications = @unread
    when 'challenge_invite'
      @notifications = @notifications.where(type: @type)
    end
  end
end
