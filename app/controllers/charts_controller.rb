class ChartsController < ApplicationController
  before_action :redirect_user
  before_action :set_goal, only: %i[ habit task ]

  def habit
    if @goal
      @habits = current_user.habits.where(goal_id: @goal)
    else
      @habits = current_user.habits
    end
  end

  def task
    if @goal
      @tasks = current_user.tasks.where(goal_id: @goal)
    else
      @tasks = current_user.tasks
    end
  end

  private

  def set_goal
    @goal = Goal.find(params[:goal_id]) if params[:goal_id]
  end

end
