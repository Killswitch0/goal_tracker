# == Schema Information
#
# Table name: challenges
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  deadline    :datetime
#  user_id     :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :challenge do
    name { 'MyString' }
    description { 'MyText' }
    deadline { (DateTime.now + 1.day).strftime('%Y-%m-%dT%H:%M:%S') }
    user { nil }
  end
end
