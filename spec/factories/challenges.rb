FactoryBot.define do
  factory :challenge do
    name { 'MyString' }
    description { 'MyText' }
    deadline { (DateTime.now + 1.day).strftime('%Y-%m-%dT%H:%M:%S') }
    user { nil }
  end
end
