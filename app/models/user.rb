class User < ActiveRecord::Base
  attr_accessible :username, :name, :password, :password_confirmation

  validates :name, presence: true
  validates :username, presence: true, uniqueness: {case_sensitive: false}

  before_save { |user| user.username = username.downcase }
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
