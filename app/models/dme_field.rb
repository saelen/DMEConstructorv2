require 'pp'

class DmeField < ActiveRecord::Base
  belongs_to :dme_table
  attr_accessible :db_column_name, :db_type, :db_scale, :db_limit, :db_precision, :display_name,
                  :type, :active, :lookup, :lookup_dme_table_id, :lookup_display_column,
                  :visible, :sort_order, :read_only

  validates_presence_of :db_column_name, :db_type, :dme_table_id

  #We need to override update attributes for this to make sure we push the migration down
  #to the database first.
  def update_attributes(attributes)
    logger.debug 'attributes passed in: ' + attributes.pretty_inspect
    change_options ={
        :limit => attributes[:db_limit],
        :scale => attributes[:db_scale],
        :precision => attributes[:db_precision]
    }
    change_options.delete(:limit) if ['integer', 'decimal'].include?(attributes[:db_type])
    change_options.delete(:scale) if ['string'].include?(attributes[:db_type])
    change_options.delete(:precision) if ['string'].include?(attributes[:db_type])

    logger.debug 'Change Options: ' + change_options.pretty_inspect
    self.dme_table.ut.migration.change_column self.dme_table.table_name, self.db_column_name, attributes[:db_type].to_sym,
                                              change_options

    if attributes[:db_column_name] != self.db_column_name
      self.dme_table.ut.migration.rename_column self.dme_table.table_name, self.db_column_name, attributes[:db_column_name]
    end
    super(attributes)
  end

  def create
    logger.debug "create method called what?"
    if !(self.dme_table.ut.columns.any? { |s| s.name == self.db_column_name })
      #Our column does not exist yet .... lets add it.
      add_options = {
          :limit => self.db_limit,
          :scale => self.db_scale,
          :precision => self.db_precision
      }
      add_options.delete(:limit) if ['integer', 'decimal'].include?(self.db_type)
      add_options.delete(:scale) if ['string'].include?(self.db_type)
      add_options.delete(:precision) if ['string'].include?(self.db_type)
      self.dme_table.ut.migration.add_column self.dme_table.table_name, self.db_column_name, self.db_type, add_options
    end
    super
  end

  #Prior to deleting the entry for this table remove the column from the underlying construction table
  def destroy
    if self.dme_table.ut.columns.any? { |s| s.name == self.db_column_name }
      self.dme_table.ut.migration.remove_column self.dme_table.table_name.to_sym, self.db_column_name.to_sym
    end
  end

  def primary_key?
    self.db_column_name == self.dme_table.ut.primary_key
  end

end