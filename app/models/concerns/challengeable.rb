module Challengeable
  extend ActiveSupport::Concern


  included do
    def has_goals_within_challenge?(challenge)
      challenge_goals.where(challenge_id: challenge).present?
    end
  end
end