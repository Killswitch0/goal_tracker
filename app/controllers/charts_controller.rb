class ChartsController < ApplicationController
  before_action :redirect_user
  before_action :set_goal, only: %i[ habit task ]

  # GET /chart/habit
  #----------------------------------------------------------------------------
  def habit
    @habits = if @goal
                current_user.habits.where(goal_id: @goal)
              else
                current_user.habits
              end
  end

  # GET /chart/task
  #----------------------------------------------------------------------------
  def task
    @tasks = if @goal
               current_user.tasks.where(goal_id: @goal)
             else
               current_user.tasks
             end
  end

  private

  def set_goal
    @goal = Goal.find(params[:goal_id]) if params[:goal_id]
  end

end
