module Streakable
  extend ActiveSupport::Concern

  def is_habit?
    self.is_a?(Habit)
  end

  private

  ### method for notice ###
  #
  # Checks if the habits is in "almost streak" state
  # when true then notify_almost_streak
  def almost_streak?
    all_items = is_habit? ? goal.habits.count : goal.tasks.count
    return if all_items == 1

    completed = is_habit? ? goal.habits.completed_today.count : goal.tasks.where(complete: true).size
    streak_range = is_habit? ? [2, 4] : [1, 4]
    calculation = (all_items - completed)
    calculation >= streak_range.first && calculation <= streak_range.last &&
      all_items != 0 &&
      (is_habit? ? completion_dates.created_today.count.zero? : complete?)
  end

  def notify_almost_streak
    if is_habit?
      HabitAlmostNotification.with(habit: self, goal: goal).deliver(goal.user)
    else
      TaskAlmostNotification.with(task: self, goal: goal).deliver(goal.user)
    end
  end
end
