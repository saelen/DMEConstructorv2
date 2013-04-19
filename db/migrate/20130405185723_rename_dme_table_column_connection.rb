class RenameDmeTableColumnConnection < ActiveRecord::Migration
  def change
    rename_column :dme_tables, :connection_id, :dme_connection_id
  end
end
