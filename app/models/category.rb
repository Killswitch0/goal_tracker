class Category < ApplicationRecord
  belongs_to :user

  has_many :goals

  validates :name, presence: true, uniqueness: { scope: :user_id },
            format: { with: /[A-Z]+[a-z]*/ },
            length: { minimum: 2, maximum: 10 }

end
