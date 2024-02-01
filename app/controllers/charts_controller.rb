class ChartsController < ApplicationController
  before_action :redirect_user
  before_action :set_goal, only: %i[habit task]
  before_action :set_period

  # TODO - refactor for more readablity

  # GET /chart/habit
  #----------------------------------------------------------------------------
  def habit
    @habits = 
      if @goal
        current_user.habits.where(goal_id: @goal)
      else
        current_user.habits
      end
  end

  def tasks 
    render json: current_user.tasks.group(:name).group_by_period(@period, :complete_date).count.chart_json
  end

  def completed_tasks
    render json: current_user.tasks.completed.group(:name).group_by_period(@period, :complete_date).count.chart_json
  end

  def uncompleted_tasks
    render json: current_user.tasks.uncompleted.group(:name).group_by_period(@period, :complete_date).count.chart_json
  end

  def habits
    habits = current_user.habits
    habits = Habit.habits_with_completion_data(habits, @period)

    render json: habits
  end

  def habits_completions
    habits = Habit.habits_completions(current_user)
    habits = Habit.habits_with_completion_data(habits, @period)

    render json: habits
  end

  def habits_by_completions
    @top_three_habits = Habit.top_this_month(current_user)
    habits = Habit.habits_with_completion_data(@top_three_habits, @period)

    render json: habits
  end

  # GET /chart/task
  #----------------------------------------------------------------------------
  def task
    @tasks = 
      if @goal
        current_user.tasks.where(goal_id: @goal)
      else
        current_user.tasks
      end
  end

  private

  def set_goal
    @goal = Goal.find(params[:goal_id]) if params[:goal_id]
  end

  def set_period
    @period = { 
      'day' => :day,
      'week' => :week,
      'month' => :month
    }.fetch(
        params[:period],
        :day
    )
  end
end
