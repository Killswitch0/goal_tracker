class Category < ApplicationRecord
  has_many :goals

  validates :name, presence: true, uniqueness: true
end
