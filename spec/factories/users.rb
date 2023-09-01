FactoryBot.define do
  factory :user do
    name { Faker::Name.unique.name.delete('.').split.first }
    email { Faker::Internet.unique.email }
    password { 'Aaaaaa1' }
    email_confirmed { true }
    confirm_token { nil }
    old_password { 'Aaaaaa1' }
  end
end