module GoalsHelper
  include TasksHelper

  AVAILABLE_COLORS = [['Purple', 'rgb(140,8,246)'],
                      ['Blue', 'rgb(17,85,253)'],
                      ['Red', 'rgb(255,18,12)'],
                      ['Pink', 'rgb(255,125,253)'],
                      ['Cyan', 'rgb(1,240,253)'],
                      ['Yellow', 'rgb(255,255,33)'],
                      ['Gold', 'rgb(252,206,24)'],
                      ['Midnight blue', 'rgb(14,31,82)']]

  def complete?
    complete == true
  end

  def goals_complete(goals)
    comp = goals.where(complete: true).count
    goals = goals.count
    "#{comp}/#{goals}"
  end


end
