class UserChangeRememberToken < ActiveRecord::Migration
  def up
    User.find_all_by_remember_token(nil).each do |f|
      f.update_attribute :remember_token, SecureRandom.urlsafe_base64
    end
  end
end
