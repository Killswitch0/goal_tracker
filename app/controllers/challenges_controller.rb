class ChallengesController < ApplicationController
  include ChallengeInvitation

  before_action :redirect_user
  before_action :set_invite, only: %i[index show new]
  before_action :set_invitation, only: %i[confirm_invitation decline_invitation leave show]

  helper_method :sort_column, :sort_direction

  # GET /challenges
  #----------------------------------------------------------------------------
  def index
    accepted_challenges = Challenge.includes(:challenge_users)
                                   .where(
                                     challenge_users: {
                                       user: current_user, confirm: true
                                     }
                                   ).order("#{Challenge.table_name}.#{sort_column} #{sort_direction}")

    @challenges = if params[:search]
                    accepted_challenges.search(params[:search], current_user, Challenge.table_name)
                  else
                    accepted_challenges
                  end
  end

  def new
    @challenge = Challenge.new
    @challenge_goal = ChallengeGoal.new
  end

  # GET /challenges/1
  #----------------------------------------------------------------------------
  def show
    require_invitation

    @challenge = Challenge.find(params[:id])

    if @challenge
      @members = User.joins(:challenge_users)
                     .where(
                       challenge_users: {
                         confirm: true
                       }).distinct
    end

    @challenge_goals = if params[:filter]
                         @challenge.goals.where(user: current_user)
                       else
                         @challenge.goals.sort_by_completed_tasks
                       end

    mark_notifications_as_read if params[:mark_as_read] == 'true'
  end

  # POST /challenges
  #----------------------------------------------------------------------------
  def create
    @challenge = Challenge.new(challenge_params)
    @challenge.user_id = current_user.id

    if @challenge.save
      ChallengeUser.create(user: current_user, challenge: @challenge, confirm: true)
      flash[:noticed] = t('.success')
      redirect_to challenge_path(@challenge)
    else
      flash[:danger] = t('.fail')
      render :new
    end
  end

  # DELETE /challenges/1
  #----------------------------------------------------------------------------
  def destroy
    @challenge = Challenge.find(params[:id])
    @challenge.destroy
    flash[:noticed] = t('success')
    redirect_to challenges_path
  end

  def add_goal
    @challenge = Challenge.find(params[:id])
    @challenge_goal = ChallengeGoal.new
    @challenge_user = current_user.challenge_users.find_by(challenge: @challenge)

    if request.post?
      @challenge_goal = current_user
                          .challenge_goals
                          .build(
                            goal_id: params[:goal_id],
                            challenge: @challenge,
                            challenge_user: @challenge_user
                          )

      if @challenge_goal.save
        flash[:noticed] = t('.success')
        redirect_to @challenge
      else
        flash[:danger] = t('.fail')
        render :add_goal
      end
    end
  end

  # POST /challenges/1/create_invitation
  #----------------------------------------------------------------------------
  def create_invitation
    @challenge = Challenge.find(params[:id])

    if request.post?
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
    if @invitation.destroy
      flash[:noticed] = t('challenges.leave.success')
    else
      flash[:noticed] = t('challenges.leave.fail')
    end

    redirect_to challenges_path
  end

  def destroy_goal
    @challenge = Challenge.find(params[:id])
    @goal = Goal.find(params[:goal_id])
    @challenge_goal = ChallengeGoal.where(challenge_id: @challenge, user: current_user, goal_id: @goal).first

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
end
