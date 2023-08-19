class User < ApplicationRecord
  include Rememberable
  include Recoverable

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # Виртуальный аттрибут. В базу данных он попадать не будет. Просто чтобы
  # на объекте существовал метод old_password, с помощью которого мы будем
  # отрисовывать новое текстовое поле в форме, а потом проверять его значение.
  # admin_edit: true мы мерджим в password_resets_controller в user_params,
  # чтобы при восстановлении пароля не требовалась валидация correct_old_password
  attr_accessor :old_password, :admin_edit

  has_many :goals, dependent: :destroy
  has_many :habits, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :goal_users
  has_many :common_goals, through: :goal_users, source: :goal

  # noticed gem association
  has_many :notifications, as: :recipient, dependent: :destroy

  has_secure_password validations: false

  validates :name, presence: true
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :password, confirmation: true, allow_blank: true, presence: true, length: { minimum: 6 }

  validate :password_presence
  validate :correct_old_password, on: :update, if: -> { password.present? && !admin_edit }

  before_save { self.email = email.downcase }

  before_create :confirmation_token

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    save!(validate: false)
  end

  private

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

    msg = 'complexity requirement not met. Length should be 8-70 characters and ' \
          'include: 1 uppercase, 1 lowercase, 1 digit and 1 special character'
    errors.add :password, msg
  end

  def password_presence
    errors.add(:password, :blank) unless password_digest.present?
  end

  def correct_old_password
    # password_digest_was - этот метод RoR создает автомат,
    # постфикс _was говорит о том, что нужно вытащить старый digest,
    # который хранится в БД, а не в памяти
    return if BCrypt::Password.new(password_digest_was).is_password?(old_password)

    errors.add :old_password, 'is incorrect'
  end

end
