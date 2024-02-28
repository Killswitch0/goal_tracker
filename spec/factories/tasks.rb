# == Schema Information
#
# Table name: tasks
#
#  id            :bigint           not null, primary key
#  name          :string
#  complete      :boolean          default(FALSE)
#  goal_id       :bigint           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint           not null
#  deadline      :datetime
#  complete_date :date
#
FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "My String #{n}".truncate(15) }
    complete { false }
    deadline { Date.today + 3.days }
  end
end
