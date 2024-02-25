class ChallengesController < ApplicationController
  include ChallengeInvitation

  before_action :redirect_user
  before_action :set_invite, only: %i[index show new]
  before_action :set_invitation, only: %i[confirm_invitation decline_invitation leave show]
  before_action :set_challenge, only: %i[destroy destroy_user add_goal create_invitation destroy_goal]

  helper_method :sort_column, :sort_direction

  # GET /challenges
  #----------------------------------------------------------------------------
  def index
    accepted_challenges =
      current_user
      .joined_challenges
      .order("#{Challenge.table_name}.#{sort_column} #{sort_direction}")

    @challenges =
      if params[:search]
        accepted_challenges.search(params[:search], current_user, Challenge.table_name)
      else
        accepted_challenges
      end
  end

  # GET /challenges/1
  #----------------------------------------------------------------------------
  def show
    require_invitation

    @challenge = Challenge.find(params[:id])

    @members = @challenge.users if @challenge

    @challenge_goals =
      if params[:filter]
        @challenge.goals.where(user: current_user)
      else
        @challenge.goals.sort_by_completed_tasks
      end

    mark_notifications_as_read
  end

  # GET /challenges/new
  #----------------------------------------------------------------------------
  def new
    @challenge = Challenge.new
    @challenge_goal = ChallengeGoal.new
  end

  # POST /challenges
  #----------------------------------------------------------------------------
  def create
    @challenge = Challenge.new(challenge_params)
    @challenge.user_id = current_user.id

    respond_to do |format|
      if @challenge.save
        ChallengeUser.create(user: current_user, challenge: @challenge, confirm: true)
        flash[:noticed] = t('.success')
        format.html { redirect_to challenge_path(@challenge) }
      else
        flash[:danger] = t('.fail')
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /challenges/1
  #----------------------------------------------------------------------------
  def destroy
    @challenge.destroy
    flash[:noticed] = t('.success')
    redirect_to challenges_path
  end

  # DELETE /challenge_users/1
  #----------------------------------------------------------------------------
  def destroy_user
    @challenge_user = @challenge.challenge_users.find_by(user_id: params[:user_id])
    @challenge_user.destroy
    flash[:noticed] = t('.success')
    redirect_to @challenge
  end

  # POST /challenges/1/add_goal
  #----------------------------------------------------------------------------
  def add_goal
    @challenge_goal = ChallengeGoal.new

    @challenge_user = ChallengeUser.find_by(
      challenge: @challenge,
      user: current_user
    )

    return unless request.post?

    @challenge_goal = current_user.challenge_goals.build(
      goal_id: params[:goal_id],
      challenge: @challenge,
      challenge_user: @challenge_user
    )

    respond_to do |format|
      if @challenge_goal.save
        flash[:noticed] = t('.success')
        format.html { redirect_to @challenge }
      else
        flash[:danger] = t('.fail')
        format.html { render :add_goal, status: :unprocessable_entity }
        format.turbo_stream { render :add_goal_update, status: :unprocessable_entity }
      end
    end
  end

  # POST /challenges/1/create_invitation
  #----------------------------------------------------------------------------
  def create_invitation
    return unless request.post?

    invited_user = User.find_by(email: params[:email])

    if invited_user
      @invitation = ChallengeUser.new(challenge: @challenge, user: invited_user)

      if @invitation.save
        flash[:noticed] = t('.success', invited_user: invited_user.email)
      elsif @invitation.present?
        flash[:danger] = t('.already')
      else
        flash[:danger] = t('.fail')
      end
    else
      flash[:danger] = t('.not_found')
    end

    redirect_to @challenge
  end

  # PUT /challenge/1/confirm_invitation
  #----------------------------------------------------------------------------
  def confirm_invitation
    if @invitation
      @invitation.update(confirm: true)
      flash[:noticed] = t('.success', challenge_name: @invitation.challenge.name)
    else
      flash[:danger] = t('.fail')
    end

    redirect_to challenges_path
  end

  # DELETE /challenge/1/decline_invitation
  #----------------------------------------------------------------------------
  def decline_invitation
    if @invitation
      @invitation.destroy
      flash[:noticed] = t('.success', challenge_name: @invitation.challenge.name)
    else
      flash[:danger] = t('.fail')
    end

    redirect_to challenges_path
  end

  # DELETE /challenge/1/leave
  #----------------------------------------------------------------------------
  def leave
    flash[:noticed] = if @invitation.destroy
                        t('.success')
                      else
                        t('.fail')
                      end

    redirect_to challenges_path
  end

  # DELETE /challenges/:id/destroy_goal
  #----------------------------------------------------------------------------
  def destroy_goal
    @goal = Goal.find(params[:goal_id])
    @challenge_goal = ChallengeGoal.find_by(
      challenge_id: @challenge,
      user: current_user,
      goal_id: @goal
    )

    if @challenge_goal
      @challenge_goal.destroy
      flash[:noticed] = "Goal was successfully destroyed from #{@challenge.name}"
    else
      flash[:noticed] = "Goal was not destroyed from #{@challenge.name}"
    end

    redirect_to @challenge
  end

  private

  def challenge_params
    params.require(:challenge).permit(:name, :description, :deadline)
  end

  def set_challenge
    @challenge = Challenge.find(params[:id])
  end
end
