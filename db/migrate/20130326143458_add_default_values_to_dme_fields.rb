class AddDefaultValuesToDmeFields < ActiveRecord::Migration
  def change
    change_column :dme_fields, :active, :boolean, :default => false, :null => false
    add_column :dme_fields, :read_only, :boolean, :default => false, :null => false
  end
end
