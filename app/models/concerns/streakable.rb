module Streakable
  extend ActiveSupport::Concern

  private

  ### method for notice ###
  #
  # Checks if the habits is in "almost streak" state
  # when true then notify_almost_streak
  def almost_streak?
    all_items = goal.send(self.class.name.pluralize.downcase.to_s)&.count

    return false if all_items.nil?

    calc_condition = (all_items - completed_count).between?(2, 4)

    calc_condition &&
      completion_condition
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
end
