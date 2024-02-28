# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  goal_id    :bigint
#  user_id    :bigint           not null
#
FactoryBot.define do
  factory :category do
    name { 'Mycategory' }
    user
  end
end
