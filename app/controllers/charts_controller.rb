class ChartsController < ApplicationController
  before_action :redirect_user
  before_action :set_goal, only: %i[habit habits_json]
  before_action :set_period

  # GET /chart/habit
  #----------------------------------------------------------------------------
  def habit; end

  # GET /chart/task
  #----------------------------------------------------------------------------
  def task; end

  #----------------------------------------------------------------------------
  def tasks_json
    tasks = current_user.tasks
    tasks = tasks.where(goal_id: @goal) if @goal

    render json: tasks.group(:name).group_by_period(@period, :complete_date).count.chart_json
  end

  #----------------------------------------------------------------------------
  def habits_json
    habits = current_user.habits
    habits = habits.where(goal_id: @goal) if @goal
    @habits = Habit.habits_with_completion_period_data(habits, @period).chart_json

    render json: @habits 
  end

  #----------------------------------------------------------------------------
  def habits_current_month_completions_json
    @top_three_habits = Habit.top_this_month(current_user)
    habits = Habit.habits_with_completion_month_data(@top_three_habits).chart_json

    render json: habits
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
