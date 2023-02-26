class Goal < ApplicationRecord
  belongs_to :user

  has_many :habits

  validates :name, presence: true
  validates :description, presence: true
end
