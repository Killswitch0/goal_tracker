module ChallangeHelper
  include DashboardHelper

  def load_level_color(tasks)
    tasks = tasks.count

    case
    when tasks <= 3
      '#797773'
    when tasks <= 6
      '#2060E0'
    when tasks > 6
      '#EBA031'
    end
  end

  def winner(challenge)
    return if challenge.deadline > Date.today

    challenge.determine_winner
  end
end
