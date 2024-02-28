# == Schema Information
#
# Table name: goals
#
#  id                    :bigint           not null, primary key
#  name                  :string
#  description           :string
#  days_completed        :integer          default(0)
#  user_id               :bigint           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  deadline              :datetime
#  complete              :boolean          default(FALSE)
#  category_id           :bigint           not null
#  color                 :string
#  tasks_count           :integer          default(0)
#  tasks_completed_count :integer          default(0), not null
#
FactoryBot.define do
  factory :goal do
    name { 'My goal is the best' }
    description { 'MyString' }
    deadline { Date.today + 3.days }
    color { 'Red' }
    user
    category
  end
end
