# == Schema Information
#
# Table name: completion_dates
#
#  id         :bigint           not null, primary key
#  date       :date
#  habit_id   :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :completion_date do
    date { Time.now.utc }
  end
end
