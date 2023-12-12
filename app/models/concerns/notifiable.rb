module Notifiable
  extend ActiveSupport::Concern

  module Base
    private

    def send_notification(subtype: '', params:)
      "#{self.class.name}#{subtype.capitalize}Notification".constantize.with(params).deliver_later(self.user)
    end

    # { habit: self, goal: goal }
    def notification_params
      raise NotImplementedError
    end

    def cleanup_notifications
      class_name = self.class.name.dup

      class_name.chars.each_with_index do |l, i|
        break if class_name[i + 1].nil?

        if l == class_name[i].downcase && class_name[i + 1] == class_name[i + 1]&.upcase
          class_name.insert(i + 1, '_')
        end
      end

      method_name = "notifications_as_#{class_name.downcase}".to_sym
      self.send(method_name).destroy_all
    end
  end

  module Create
    def notify_create
      self.send_notification(params: notification_params)
    end
  end

  module Deadline
    def notify_deadline
      self.send_notification(subtype: 'Deadline', params: notification_params)
    end
  end

  module AlmostStreak
    def notify_almost_streak
      self.send_notification(subtype: 'Almost', params: notification_params)
    end
  end
end