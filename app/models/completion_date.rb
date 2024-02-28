# == Schema Information
#
# Table name: completion_dates
#
#  id         :bigint           not null, primary key
#  date       :date
#  habit_id   :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class CompletionDate < ApplicationRecord
  include Streakable

  belongs_to :habit

  scope :created_today, -> { where('created_at >= ?', Date.today.beginning_of_day) }
  scope :calendar_completed_today, ->(date) { where('date = ?', date.to_date) }
end
