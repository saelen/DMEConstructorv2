class CreateDmeTables < ActiveRecord::Migration
  def change
    create_table :dme_tables do |t|
      t.string :display_name
      t.string :database_name
      t.references :connection

      t.timestamps
    end
  end
end
