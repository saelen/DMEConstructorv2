require 'pp'

class DmeField < ActiveRecord::Base
  belongs_to :dme_table
  attr_accessible :db_column_name, :db_type, :db_scale, :db_limit, :display_name,
                  :type, :active, :lookup, :lookup_dme_table_id, :lookup_display_column,
                  :visible, :order

  validates_presence_of :db_column_name, :db_type, :dme_table_id

  #We need to override update attributes for this to make sure we push the migration down
  #to the database first.
  def update_attributes(attributes)
    logger.debug 'attributes passed in: ' + PP.pp(attributes).to_s
    change_options =
        {
            :limit => attributes[:db_limit],
            :scale => attributes[:db_scale]
        }
    change_options.delete(:limit) if ['integer'].include?(attributes[:db_type])

    logger.debug 'Change Options: ' + PP.pp(change_options).to_s
    self.dme_table.ut.migration.change_column self.dme_table.table_name, self.db_column_name, attributes[:db_type].to_sym,
                                              change_options

    if attributes[:db_column_name] != self.db_column_name
      self.dme_table.ut.migration.rename_column self.dme_table.table_name, self.db_column_name, attributes[:db_column_name]
    end
    super(attributes)
  end

end