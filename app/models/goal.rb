class Goal < ApplicationRecord
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

  def complete?
    self.complete == true
  end

  def self.search(search, user)
    where('lower(name) LIKE ? AND user_id = ?', "%#{search.downcase}%", "#{user.id}") if search
  end
end
