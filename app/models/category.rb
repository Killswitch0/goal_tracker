class Category < ApplicationRecord
  belongs_to :user

  has_many :goals, dependent: :destroy

  validates :name, presence: true, uniqueness: true,
            format: { with: /[A-Z]+[a-z]*/ },
            length: { minimum: 2, maximum: 10 }
end
