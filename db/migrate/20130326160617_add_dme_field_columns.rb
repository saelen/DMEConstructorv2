class AddDmeFieldColumns < ActiveRecord::Migration
  def change
    add_column :dme_fields, :visible, :boolean, :default => false
    add_column :dme_fields, :order, :integer
  end
end
