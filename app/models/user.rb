# == Schema Information
#
# Table name: users
#
#  id                      :integer          not null, primary key
#  name                    :string(255)
#  email                   :string(255)
#  password_digest         :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  email_confirmed         :boolean          default(FALSE)
#  confirm_token           :string(255)
#  auth_token              :string(255)
#  password_reset_token    :string(255)
#  password_reset_sent_at  :datetime
#  role                    :integer          default(0), not null
#  gravatar_hash           :string(255)
#
# Indexes
#
#  index_users_on_role  (role)
#

class User < ApplicationRecord
  include Rememberable
  include Recoverable

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # Virtual attribute. It will not enter the database. Just to
  # the old_password method existed on the object, with the help of which we will
  # draw a new text field on the form and then check its value.
  # admin_edit: true we merge in password_resets_controller in user_params,
  # so that when recovering a password, validation is not required correct_old_password
  attr_accessor :old_password, :admin_edit

  has_many :goals, dependent: :destroy
  has_many :habits, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :challenge_users, dependent: :destroy
  has_many :challenges, through: :challenge_users, dependent: :destroy
  has_many :challenge_goals, dependent: :destroy

  # noticed gem association
  has_many :notifications, as: :recipient, dependent: :destroy

  has_one_attached :avatar

  has_secure_password validations: false

  validates :name, presence: true,
                   format: {
                     with: /\A[A-Za-z]+\z/,
                     message: :name_format
                   }
  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, confirmation: true,
                       allow_blank: true,
                       presence: true,
                       format: {
                         with: /\A(?=.*[A-Za-z])(?=.*\d).+\z/,
                         message: :password_format
                       },
                       length: { minimum: 6, maximum: 10,
                                 message: :password_length
            }

  validate :password_presence
  validate :correct_old_password, on: :update, if: -> { password.present? && !admin_edit }

  before_save { self.email = email.downcase }
  before_save :set_gravatar_hash, if: :email_changed?

  before_create :confirmation_token

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    save!(validate: false)
  end

  def admin_role?
    self.role == 1
  end

  # returns user goal in challenge or nil
  def user_goal_in(challenge)
    challenge_goals.where(challenge: challenge, user: self).first&.goal
  end

  private

  def set_gravatar_hash
    return unless email.present?

    hash = Digest::MD5.hexdigest(email.strip.downcase)
    self.gravatar_hash = hash
  end

  def digest(string)
    cost = if ActiveModel::SecurePassword
                .min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end

  def confirmation_token
    if self.confirm_token.blank?
      self.confirm_token = SecureRandom.urlsafe_base64.to_s
    end
  end

  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank? || password =~ /(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-])/

    msg = I18n.t('activerecord.errors.models.user.password_complexity')
    errors.add :password, msg
  end

  def password_presence
    errors.add(:password, :blank) unless password_digest.present?
  end

  def correct_old_password
    # password_digest_was - this RoR method creates automatically,
    # the _was postfix says to pull out the old digest,
    # which is stored in the database, not in memory
    return if BCrypt::Password.new(password_digest_was).is_password?(old_password)

    errors.add :old_password, I18n.t('activerecord.errors.messages.incorrect')
  end

end
