class CreateTableDmeField < ActiveRecord::Migration
  def change
    create_table :dme_fields do |t|
      t.string :display_name
      t.string :type
      t.boolean :active
      t.boolean :lookup
      t.integer :lookup_dme_table_id
      t.string :lookup_display_column
      t.references :dme_table
      t.timestamps
    end
  end
end
