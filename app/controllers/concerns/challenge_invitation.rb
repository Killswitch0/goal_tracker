module ChallengeInvitation
  extend ActiveSupport::Concern

  included do
    private

    # Requires challenge invitation to get access
    def require_invitation
      @challenge = Challenge.find_by(id: params[:id])
      return if @challenge.blank?

      invitation = ChallengeUser.find_by(challenge: @challenge, user: current_user, confirm: true)

      return if invitation

      flash[:noticed] = t('.create_invitation.need_confirm')
      redirect_to challenges_path
    end

    def set_invitation
      @challenge = Challenge.find(params[:id])
      @invitation = ChallengeUser.find_by(challenge: @challenge, user: current_user)
    end

    def set_invite
      @invites ||= ChallengeUser.where(confirm: false, user: current_user)
    end

    def mark_notifications_as_read
      return unless current_user

      notifications_to_mark_as_read = @invitation.notifications_as_challenge_user.where(recipient: current_user)
      notifications_to_mark_as_read.update_all(read_at: Time.zone.now)
    end
  end
end