class Goal < ApplicationRecord
  include Searchable
  
  AVAILABLE_COLORS = [%w[Purple rgb(140,8,246)],
                      %w[Blue rgb(17,85,253)],
                      %w[Red rgb(255,18,12)],
                      %w[Pink rgb(255,125,253)],
                      %w[Cyan rgb(1,240,253)],
                      %w[Yellow rgb(255,255,33)],
                      %w[Gold rgb(252,206,24)],
                      %w[Midnight blue rgb(14,31,82)]]

  belongs_to :user
  belongs_to :category

  has_many :habits, dependent: :destroy
  has_many :tasks, dependent: :destroy

  validates :name, presence: true, uniqueness: true,
            format: { with: /[A-Z]+[a-z]*/ },
            length: { minimum: 5, maximum: 50 }

  validates :description, presence: true,
            format: { with: /\A(.|\s)*[a-zA-Z]+(.|\s)*\z/ },
            length: { minimum: 7, maximum: 200 }

  validates :category_id, presence: true
  validates :color, presence: true
end
