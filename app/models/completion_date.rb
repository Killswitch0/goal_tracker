# == Schema information
#
# Table name: completion_dates
#
#  id         :integer          not null, primary key
#  date       :date
#  habit_id   :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_completion_dates_on_habit_id  (habit_id)
#

class CompletionDate < ApplicationRecord
  include Streakable

  belongs_to :habit

  scope :created_today, -> { where('created_at >= ?', Date.today.beginning_of_day) }
  scope :calendar_completed_today, -> (date) { where('date = ?', date.to_date) }
end
