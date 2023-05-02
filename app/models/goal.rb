class Goal < ApplicationRecord
  belongs_to :user
  belongs_to :category

  has_many :habits, dependent: :destroy
  has_many :tasks, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true
  validates :category_id, presence: true


  def complete?
    self.complete == true
  end
end
