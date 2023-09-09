module ChallangeHelper
  include DashboardHelper

  def load_level_color(tasks)
    tasks = tasks.count

    case
    when tasks <= 4
      '#797773'
    when tasks <= 7
      '#2060E0'
    when tasks > 7
      '#9FA3AB '
    end
  end
end
