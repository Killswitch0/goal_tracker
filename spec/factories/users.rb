# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  name                   :string
#  email                  :string
#  password_digest        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email_confirmed        :boolean          default(FALSE)
#  confirm_token          :string
#  auth_token             :string
#  password_reset_token   :string
#  password_reset_sent_at :datetime
#  role                   :integer          default(0), not null
#  gravatar_hash          :string
#  tasks_count            :integer          default(0)
#
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
