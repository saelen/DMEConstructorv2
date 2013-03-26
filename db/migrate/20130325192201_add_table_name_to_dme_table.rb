class AddTableNameToDmeTable < ActiveRecord::Migration
  def change
    add_column :dme_tables, 'table_name', :string
  end
end
