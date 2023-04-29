class Goal < ApplicationRecord
  belongs_to :user

  has_one :category

  has_many :habits
  has_many :tasks

  validates :name, presence: true
  validates :description, presence: true


  def complete?
    self.complete == true
  end
end
