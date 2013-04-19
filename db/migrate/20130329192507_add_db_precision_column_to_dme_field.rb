class AddDbPrecisionColumnToDmeField < ActiveRecord::Migration
  def change
    add_column :dme_fields, :db_precision, :string
  end
end
