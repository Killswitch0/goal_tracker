class CompletionDate < ApplicationRecord
  belongs_to :habit

  scope :created_today, -> { where('created_at >= ?', Date.today.beginning_of_day) }
  scope :calendar_completed_today, -> (date) { where('date = ?', date) }
end
