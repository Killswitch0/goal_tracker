# == Schema information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  goal_id    :bigint
#  user_id    :bigint           not null
#
# Indexes
#
#  index_categories_on_goal_id  (goal_id)
#  index_categories_on_user_id  (user_id)
#

class Category < ApplicationRecord
  belongs_to :user

  has_many :goals

  validates :name, presence: true, uniqueness: { scope: :user_id },
                   format: {
                     with: /\A\p{L}+\z/u,
                     message: :only_letters
                   },
                   length: { minimum: 2, maximum: 20 }

end
