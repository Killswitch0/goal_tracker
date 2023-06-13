class CompletionDate < ApplicationRecord
  belongs_to :habit

  scope :created_today, -> { where('created_at >= ?', Date.today.beginning_of_day) }
end
