class AddDmeColumnDbLimit < ActiveRecord::Migration
  def change
    add_column :dme_fields, :db_limit, :integer
  end
end
