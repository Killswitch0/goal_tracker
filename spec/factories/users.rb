FactoryBot.define do
  factory :user do
    name { Faker::Name.unique.name.delete('.').split.first }
    sequence(:email) { |i| "#{i}#{Faker::Internet.email}" }
    password { 'Aaaaaa1' }
    old_password { 'Aaaaaa1' }
    email_confirmed { true }
    confirm_token { nil }
  end
end
