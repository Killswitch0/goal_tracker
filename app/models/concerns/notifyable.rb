module Notifyable
  extend ActiveSupport::Concern

  module Base
    private

    def send_notification(params:, subtype: '')
      "#{self.class.name}#{subtype.capitalize}Notification".constantize.with(params).deliver(user)
    end

    # { habit: self, goal: goal }
    def notification_params
      raise NotImplementedError
    end

    def cleanup_notifications
      class_name = self.class.name.dup

      class_name.chars.each_with_index do |letter, index|
        class_name_increment = class_name[index + 1]

        break if class_name_increment.nil?

        if letter == class_name[index].downcase && class_name_increment == class_name_increment&.upcase
          class_name.insert(index + 1,
                            '_')
        end
      end

      method_name = "notifications_as_#{class_name.downcase}".to_sym
      send(method_name).destroy_all
    end
  end

  module Create
    def notify_create
      send_notification(params: notification_params)
    end
  end

  module Deadline
    def notify_deadline
      send_notification(subtype: 'Deadline', params: notification_params)
    end
  end

  module AlmostStreak
    def notify_almost_streak
      send_notification(subtype: 'Almost', params: notification_params)
    end
  end
end
