class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.string :adapter
      t.string :host
      t.string :username
      t.string :password
      t.string :default_database

      t.timestamps
    end
  end
end
