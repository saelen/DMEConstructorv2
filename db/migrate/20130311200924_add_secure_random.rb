class AddSecureRandom < ActiveRecord::Migration
  def up
    User.find_all_by_remember_token(nil).each do |f|
      f.update_attribute :remember_token, SecureRandom.urlsafe_base64
      say_with_time('Updating User: ' + f.name)
    end
  end
end
