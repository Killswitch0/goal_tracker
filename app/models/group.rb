class Group < ApplicationRecord
  belongs_to :user
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users
  has_many :notifications, through: :users
end
