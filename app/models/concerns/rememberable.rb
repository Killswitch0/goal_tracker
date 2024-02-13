module Rememberable
  extend ActiveSupport::Concern

  included do
    attr_accessor :remember_token

    def remember_me
      self.remember_token = SecureRandom.urlsafe_base64
      update_column :auth_token, digest(remember_token)
    end

    def forget_me
      update_column :auth_token, nil
      self.remember_token = nil
    end

    def remember_token_authenticated?(remember_token)
      return false if auth_token.blank?

      BCrypt::Password.new(auth_token).is_password?(remember_token)
    end
  end
end
