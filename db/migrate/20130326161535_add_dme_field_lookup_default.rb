class AddDmeFieldLookupDefault < ActiveRecord::Migration
  def change
    change_column :dme_fields, :lookup, :boolean, :default => false, :null => false
  end
end
