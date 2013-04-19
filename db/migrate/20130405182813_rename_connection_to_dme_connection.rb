class RenameConnectionToDmeConnection < ActiveRecord::Migration
  def up
    rename_table :connections, :dme_connections
  end

  def down
    rename_table :dme_connections, :connections
  end
end
