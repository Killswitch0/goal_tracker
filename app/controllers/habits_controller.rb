class HabitsController < ApplicationController
  before_action :redirect_user
  before_action :set_goal, only: %i[index new edit create update destroy]
  before_action :set_habit, only: %i[edit update destroy complete]

  helper_method :sort_column, :sort_direction

  # GET /goals/1/habits
  #----------------------------------------------------------------------------
  def index
    @goal = Goal.find(params[:goal_id])
    @habits = current_user.habits
    @completed_habits = @habits.joins(:completion_dates)
                               .where(completion_dates: { created_at: Date.today.beginning_of_day.. }, goal_id: @goal.id).distinct
    @uncompleted_habits = @habits.left_joins(:completion_dates)
                                 .where(completion_dates: { id: nil }, goal_id: @goal.id).distinct
  end

  # GET /goals/1/habits/new
  #----------------------------------------------------------------------------
  def new
    @habit = Habit.new
  end

  # GET /goals/1/habits/1
  #----------------------------------------------------------------------------
  def show; end

  # GET goals/1/habits/1/edit
  #----------------------------------------------------------------------------
  def edit; end

  # POST /goals/1/habits
  #----------------------------------------------------------------------------
  def create
    @habit = @goal.habits.build(habit_params)
    @habit.user = current_user

    if @habit.save
      flash[:noticed] = t('.success')
      redirect_to goal_path(@goal)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PUT /goals/1/habits/1
  #----------------------------------------------------------------------------
  def update
    respond_to do |format|
      if @habit.update(habit_params)
        redirect_to goal_path(@goal)
        flash[:noticed] = t('.success')
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /goals/1/habits/1
  #----------------------------------------------------------------------------
  def destroy
    @habit.destroy
    flash[:noticed] = t('.success')
    redirect_to goal_habits_path(@goal, @habit)
  end

  # GET /goals/1/habits/1/complete
  #----------------------------------------------------------------------------
  def complete
    @goal = @habit.goal

    if @habit.completed_today?
      @habit.complete_habit_today
      flash[:noticed] = t('.uncompleted')
    else
      @habit.complete_habit_today
      flash[:noticed] = t('.completed')
    end

    redirect_to goal_path(@goal)
  end

  private

  def habit_params
    params.require(:habit).permit(
      :name,
      :description,
      :days_completed,
      :completed
    )
  end

  def set_goal
    @goal = Goal.find(params[:goal_id])
  end

  def set_habit
    @habit = Habit.find(params[:id])
  end
end
