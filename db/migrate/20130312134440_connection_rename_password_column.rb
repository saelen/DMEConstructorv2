class ConnectionRenamePasswordColumn < ActiveRecord::Migration
  def up
    rename_column :connections, :password, :password_digest
  end

  def down
  end
end
