# == Schema Information
#
# Table name: goals
#
#  id                    :bigint           not null, primary key
#  name                  :string
#  description           :string
#  days_completed        :integer          default(0)
#  user_id               :bigint           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  deadline              :datetime
#  complete              :boolean          default(FALSE)
#  category_id           :bigint           not null
#  color                 :string
#  tasks_count           :integer          default(0)
#  tasks_completed_count :integer          default(0), not null
#
class Goal < ApplicationRecord
  include Notifyable::Base
  include Notifyable::Create
  include Searchable
  include ValidationConstants

  belongs_to :user
  belongs_to :category

  has_many :habits, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :challenge_goals, dependent: :destroy

  # noticed gem association
  has_many :notifications, through: :users

  before_destroy :cleanup_notifications

  has_noticed_notifications model_name: 'Notification'

  accepts_nested_attributes_for :category, reject_if: proc { |attributes| attributes['name'].blank? }

  validates :category_id, presence: false
  validates :color, presence: true, uniqueness: { scope: :user_id }
  validates :deadline, presence: true, comparison: { greater_than: Date.today }
  validates :color, presence: true

  validates :name, presence: true,
                   uniqueness: { scope: :user_id },
                   format: {
                     with: BASE_VALIDATION,
                     message: :text_input
                   },
                   length: {
                     minimum: 5,
                     maximum: 50
                   }

  validates :description, presence: true,
                          format: {
                            with: BASE_VALIDATION,
                            message: :text_input
                          },
                          length: {
                            minimum: 7,
                            maximum: 200
                          }

  scope :sort_by_completed_tasks, lambda {
    left_joins(:tasks)
      .group('goals.id, challenge_goals.id')
      .select(
        'goals.*, COUNT(
        CASE WHEN tasks.complete = true THEN 1 ELSE NULL END
      ) completed_tasks_count'
      )
      .order('completed_tasks_count DESC')
  }

  # Returns challenge that have current goal or nil
  #----------------------------------------------------------------------------
  def challenge_with_goal
    challenge_goals.where(goal: self).first&.challenge
  end

  #----------------------------------------------------------------------------
  def completed_tasks_cached_count # TODO: - is it really need?
    last_modified = tasks.maximum(:updated_at).utc
    cache_key = "#{self.cache_key}-#{last_modified.to_i}"

    Rails.cache.fetch(cache_key) do
      tasks.where(complete: true).count
    end
  end

  private

  # For Notifyable::Base send_notification method
  #----------------------------------------------------------------------------
  def notification_params
    { goal: self }
  end
end
