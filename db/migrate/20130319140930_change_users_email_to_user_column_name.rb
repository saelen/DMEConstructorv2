class ChangeUsersEmailToUserColumnName < ActiveRecord::Migration
  def change
    rename_column :users, :email, :username
  end
end
