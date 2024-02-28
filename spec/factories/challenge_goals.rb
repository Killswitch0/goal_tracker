# == Schema Information
#
# Table name: challenge_goals
#
#  id                :bigint           not null, primary key
#  user_id           :bigint           not null
#  goal_id           :bigint           not null
#  challenge_id      :bigint           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  challenge_user_id :bigint           not null
#
FactoryBot.define do
  factory :challenge_goal do
    user { nil }
    goal { nil }
  end
end
