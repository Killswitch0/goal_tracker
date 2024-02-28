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
class Category < ApplicationRecord
  belongs_to :user

  has_many :goals

  validates :name, presence: true,
                   uniqueness: { scope: :user_id },
                   format: {
                     with: /\A\p{L}+\z/u,
                     message: :only_letters
                   },
                   length: {
                     minimum: 2,
                     maximum: 20
                   }
end
