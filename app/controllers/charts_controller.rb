class ChartsController < ApplicationController
  before_action :redirect_user
  before_action :set_goal, only: %i[habit task]
  before_action :set_period
  before_action :default_params, only: :habit

  # GET /chart/habit
  #----------------------------------------------------------------------------
  def habit
    @chart_for = chart_params[:chart_for] = t('all_habits')
    @habits = current_user.habits
  end

  # GET /chart/task
  #----------------------------------------------------------------------------
  def task
    @chart_for = chart_params[:chart_for] = t('all_tasks')
    @tasks = current_user.tasks
  end

  #----------------------------------------------------------------------------
  def tasks_json
    tasks = current_user.tasks
    tasks = tasks.where(goal_id: @goal) if @goal

    @tasks = tasks.group(:name).group_by_period(@period, :complete_date).count.reject do |_key, value|
      value.zero?
    end.chart_json

    render json: @tasks
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
    @top_three_habits = Habit.top_this_month(current_user).take(3)
    range = Date.current.beginning_of_month..Date.current.end_of_month
    habits = Habit.habits_with_completion_period_data(@top_three_habits, :month, range:).chart_json

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

  def redirect_if_no_data; end

  def default_params
    @chart_type = chart_params[:chart_type] ||= 'line'
  end

  def chart_params
    params.permit(:chart_type, :period, :chart_for)
  end
end
