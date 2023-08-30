module GoalsHelper
  include TasksHelper
  include HabitsHelper

  AVAILABLE_COLORS = [['Purple', 'rgb(140,8,246)'],
                      ['Blue', 'rgb(17,85,253)'],
                      ['Red', 'rgb(255,18,12)'],
                      ['Pink', 'rgb(255,125,253)'],
                      ['Cyan', 'rgb(1,240,253)'],
                      ['Yellow', 'rgb(255,255,33)'],
                      ['Gold', 'rgb(252,206,24)'],
                      ['Midnight blue', 'rgb(14,31,82)']
                      ].freeze

  def available_colors
    used_colors = current_user.goals.pluck(:color)
    AVAILABLE_COLORS.map do |color|
      if used_colors.include?(color[1])
        color[0]
      else
        [color[0], color[1], { style: "background-color: #{color[1]}; color: white;" }]
      end
    end
  end

  def complete?
    complete == true
  end

  def goals_complete(goals)
    comp = goals.where(complete: true).count
    goals = goals.count
    "#{comp}/#{goals}"
  end

  def days_left(goal)
    days = (goal.deadline.to_date - Date.today).to_i

    if days.negative? || days.zero?
      0
    else
      days
    end
  end
end
