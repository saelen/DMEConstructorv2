class ConnectionsAddColumnName < ActiveRecord::Migration
  def up
    add_column :connections, :name, :string
  end

  def down
  end
end
