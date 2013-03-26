class RenameOrderColumnDmeField < ActiveRecord::Migration
  def change
    rename_column :dme_fields, :order, :sort_order
  end
end
