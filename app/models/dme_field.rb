class DmeField < ActiveRecord::Base
  belongs_to :dme_table
  attr_accessible :db_column_name, :db_type, :db_scale, :db_limit, :display_name,
                  :type, :active, :lookup, :lookup_dme_table_id, :lookup_display_column,
                  :visible, :order

  validates_presence_of :db_column_name, :db_type, :dme_table_id
end