# == Schema information
#
# Table name: challenges
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  deadline    :datetime
#  user_id     :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_challenges_on_user_id  (user_id)


class Challenge < ApplicationRecord
  has_many :challenge_users, dependent: :destroy
  has_many :users, through: :challenge_users

  has_many :challenge_goals, dependent: :destroy
  has_many :goals, through: :challenge_goals
end