class ChangePasswordFieldConnections < ActiveRecord::Migration
  def change
    remove_column :connections, :password_digest
    add_column :connections, :password, :string
  end
end
