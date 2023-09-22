FactoryBot.define do
  factory :challenge_user do
    user
    challenge
    confirm { true }
  end
end
