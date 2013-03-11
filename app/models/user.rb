class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation

  validates :name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates :password, presence: true, length: {minimum: 6}
  validates_confirmation_of :password
  validates :password_confirmation, presence: true

  has_secure_password
  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
