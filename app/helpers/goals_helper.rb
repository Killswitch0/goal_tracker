module GoalsHelper
  include TasksHelper

  def complete?
    complete == true
  end

  def goals_complete(goals)
    comp = goals.where(complete: true).count
    goals = goals.count
    "#{comp}/#{goals}"
  end
end
