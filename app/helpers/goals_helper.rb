module GoalsHelper
  AVAILABLE_COLORS = [
    ['Purple', 'rgb(140,8,246)'],
    ['Blue', 'rgb(17,85,253)'],
    ['Red', 'rgb(255,18,12)'],
    ['Pink', 'rgb(255,125,253)'],
    ['Cyan', 'rgb(1,240,253)'],
    ['Yellow', 'rgb(255,255,33)'],
    ['Gold', 'rgb(252,206,24)'],
    ['Midnight blue', 'rgb(14,31,82)'],
    ['Green', 'rgb(0,128,0)'],
    ['Orange', 'rgb(255,165,0)'],
    ['Brown', 'rgb(139,69,19)'],
    ['Gray', 'rgb(128,128,128)'],
    ['Dark red', 'rgb(139,0,0)'],
    ['Dark green', 'rgb(0,100,0)'],
    ['Maroon', 'rgb(128,0,0)'],
    ['Olive', 'rgb(128,128,0)'],
    ['Slate gray', 'rgb(112,128,144)'],
    ['Teal', 'rgb(0,128,128)'],
    ['Navy blue', 'rgb(0,0,128)'],
    ['Indigo', 'rgb(75,0,130)'],
    ['Turquoise', 'rgb(64,224,208)'],
    ['Violet', 'rgb(238,130,238)'],
    ['Chocolate', 'rgb(210,105,30)'],
    ['Sky blue', 'rgb(135,206,235)'],
    ['Deep pink', 'rgb(255,20,147)'],
    ['Lavender', 'rgb(230,230,250)'],
    ['Salmon', 'rgb(250,128,114)'],
    ['Lime green', 'rgb(50,205,50)'],
    ['Khaki', 'rgb(240,230,140)'],
    ['Hot pink', 'rgb(255,105,180)'],
    ['Medium orchid', 'rgb(186,85,211)'],
    ['Medium sea green', 'rgb(60,179,113)'],
    ['Steel blue', 'rgb(70,130,180)'],
    ['Cadet blue', 'rgb(95,158,160)'],
    ['Dark olive green', 'rgb(85,107,47)'],
    ['Rosy brown', 'rgb(188,143,143)'],
    ['Slate blue', 'rgb(106,90,205)'],
    ['Medium violet red', 'rgb(199,21,133)'],
    ['Dark orange', 'rgb(255,140,0)'],
    ['Saddle brown', 'rgb(139,69,19)'],
    ['Sea green', 'rgb(46,139,87)'],
    ['Sienna', 'rgb(160,82,45)'],
    ['Indian red', 'rgb(205,92,92)'],
    ['Medium purple', 'rgb(147,112,219)'],
    ['Olive drab', 'rgb(107,142,35)'],
    ['Royal blue', 'rgb(65,105,225)'],
    ['Tomato', 'rgb(255,99,71)'],
    ['Orchid', 'rgb(218,112,214)'],
    ['Light sea green', 'rgb(32,178,170)'],
    ['Pale violet red', 'rgb(219,112,147)'],
    ['Crimson', 'rgb(220,20,60)'],
    ['Medium aquamarine', 'rgb(102,205,170)'],
    ['Dark slate blue', 'rgb(72,61,139)'],
    ['Lawn green', 'rgb(124,252,0)'],
    ['Purple', 'rgb(128,0,128)'],
    ['Gold', 'rgb(255,215,0)'],
    ['Light coral', 'rgb(240,128,128)'],
    ['Dark slate gray', 'rgb(47,79,79)'],
    ['Dark magenta', 'rgb(139,0,139)'],
    ['Pale green', 'rgb(152,251,152)'],
    ['Lavender blush', 'rgb(255,240,245)'],
    ['Sandy brown', 'rgb(244,164,96)'],
    ['Medium spring green', 'rgb(0,250,154)'],
    ['Slate gray', 'rgb(112,128,144)'],
    ['Deep sky blue', 'rgb(0,191,255)'],
    ['Medium blue', 'rgb(0,0,205)'],
    ['Cornflower blue', 'rgb(100,149,237)'],
    ['Aquamarine', 'rgb(127,255,212)'],
    ['Dark violet', 'rgb(148,0,211)'],
    ['Orange red', 'rgb(255,69,0)'],
    ['Dark turquoise', 'rgb(0,206,209)']].freeze

  include TasksHelper
  include HabitsHelper

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
