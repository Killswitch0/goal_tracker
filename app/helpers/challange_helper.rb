module ChallangeHelper
  include DashboardHelper

  def load_level_color(tasks)
    if tasks.is_a? Integer
      tasks
    elsif tasks.nil?
      tasks = 0
    else
      tasks = tasks.count
    end

    case
    when tasks <= 3
      '#797773'
    when tasks <= 6
      '#2060E0'
    when tasks > 6
      '#EBA031'
    end
  end

  def winners_of(challenge)
    return if challenge.deadline > Date.today

    challenge.determine_category_winners
  end
end
