class AddDbColumnsToDmeFields < ActiveRecord::Migration
  def change
    add_column :dme_fields, :db_column_name, :string
    add_column :dme_fields, :db_type, :string
    add_column :dme_fields, :db_scale, :string
  end
end
