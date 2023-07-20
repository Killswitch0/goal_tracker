module Streakable
  extend ActiveSupport::Concern

  private

  def send_notification(params)
    "#{self.class.name}AlmostNotification".constantize.with(params).deliver(self.user)
  end

  ### method for notice ###
  #
  # Checks if the habits is in "almost streak" state
  # when true then notify_almost_streak
  def almost_streak?(range = nil)
    range ||= [1, 4]

    all_items = goal.send(self.class.name.pluralize.downcase.to_s)&.count
    return false if all_items.nil? || all_items == 1

    (all_items - completed_count).between?(range.first, range.last) &&
      all_items.positive? &&
      completed_condition
  end

  def notify_almost_streak
    self.send_notification(notification_params)
  end

  # count completion
  # example for habit:
  # goal.habits.completed_today.count
  def completion_count
    raise NotImplementedError
  end

  # checks it's not completed
  # example:
  # completion_dates.created_today.count.zero?
  def completion_condition
    raise NotImplementedError
  end

  # { habit: self, goal: goal }
  def notification_params
    raise NotImplementedError
  end
end
