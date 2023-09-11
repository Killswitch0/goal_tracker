module ChallangeHelper
  include DashboardHelper

  def load_level_color(tasks)
    tasks = tasks.count

    case
    when tasks <= 4
      '#797773'
    when tasks <= 7
      '#2060E0'
    when tasks >= 7
      '#EBA031'
    end
  end

  def determine_winner(goals, challenge)
    if challenge.deadline <= Date.today

      goal = goals.first
      completed = goal.tasks.where(complete: true).count
      all = goal.tasks.count

      goal.user if completed == all
    end
  end
end
