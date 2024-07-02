# == Schema Information
#
# Table name: notifications
#
#  id             :bigint           not null, primary key
#  recipient_type :string           not null
#  recipient_id   :bigint           not null
#  type           :string           not null
#  params         :jsonb
#  read_at        :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Notification < ApplicationRecord
  include Noticed::Model
  belongs_to :recipient, polymorphic: true

  after_create_commit :broadcast_notifications_list
  after_create_commit :broadcast_notifications_count
  after_create_commit :broadcast_notifications_count_header

  def recipient_unread_notifications
    Notification.includes(:recipient).where(recipient:).newest_first.unread
  end

  private

  # TODO - add feature tests
  def broadcast_notifications_list
    broadcast_append_to "notifications-list_#{recipient.id}",
                           target: "notifications-list_#{recipient.id}",
                           partial: 'layouts/notifications/notifications_list',
                           locals: { user: recipient, notifications: Notification.includes(:recipient).where(recipient:).newest_first.limit(20) }
  end

  def broadcast_notifications_count
    broadcast_replace_to "notifications-count",
                          target: "notifications-count",
                          partial: 'layouts/notifications/notifications_count',
                          locals: { current_user: recipient, unread: recipient_unread_notifications }
  end

  def broadcast_notifications_count_header
    broadcast_replace_to "notifications-count-header",
                          target: "notifications-count-header",
                          partial: 'layouts/notifications/notifications_count',
                          locals: { current_user: recipient, unread: recipient_unread_notifications }
  end
end
