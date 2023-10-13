module ChallangeHelper
  include DashboardHelper

  def load_level_color(tasks)
    case tasks
    when 0..3
      '#797773'
    when 4..6
      '#2060E0'
    else
      '#EBA031'
    end
  end

  def winners_of(challenge)
    return if challenge.deadline > Date.today

    challenge.determine_category_winners
  end
end
