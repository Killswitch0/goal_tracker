# == Schema Information
#
# Table name: habits
#
#  id             :bigint           not null, primary key
#  name           :string
#  description    :text
#  days_completed :integer          default(0)
#  user_id        :bigint           not null
#  goal_id        :bigint           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
FactoryBot.define do
  factory :habit do
    name { 'MyString' }
    description { 'MyString' }
  end
end
