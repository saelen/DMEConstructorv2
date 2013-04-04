class DmeTable < ActiveRecord::Base
  has_many :dme_fields

  attr_accessible :connection_id, :database_name, :display_name, :table_name
  attr_accessor :ut
  belongs_to :connection

  validates_presence_of :connection_id, :database_name, :display_name, :table_name
  validates_uniqueness_of :display_name

  after_initialize :setup_connection, :check_fields
  after_save :setup_connection, :check_fields
  after_update :setup_connection, :check_fields

  def check_fields
    #Check to see if the table we are pointing at has any new fields in the database.  In addition, sets existing fields
    #we do not have in the database to inactive and fields that have since shown up as active.
    logger.debug "Checking Fields..."
    begin
      #Set all records to Inactive
      self.dme_fields.update_all(:active => false)

      #Loop through the actual column's on the underlying database table
      self.ut.columns.each do |c|
        #If we are missing the record create it
        if !self.dme_fields.exists?(:db_column_name => c.name)
          logger.debug "Inserting new field #{c.name} for table #{self.table_name}"
          o = self.dme_fields.create(:db_column_name => c.name, :db_type => c.type, :db_scale => c.scale,
                                     :db_limit => c.limit, :db_precision => c.precision, :active => true)
          o.errors.each do |e|
            logger.debug e.message
          end
        end
        #Set the record as active and update the appropriate database fields
        rec = self.dme_fields.where(:db_column_name => c.name).first()
        if rec
          rec.active = true
          rec.db_type = c.type
          rec.db_scale = c.scale
          rec.db_limit = c.limit
          rec.db_precision = c.precision
          rec.save
        end
      end
    rescue Exception => e
      logger.debug "Exception in check fields: " + e.message
    end
  end

  private
  class CustomMigration < ActiveRecord::Migration
  end

  def setup_connection

    begin
      self.ut = Connection.find_by_id(self.connection_id).uc.clone
      self.ut.table_name = self.table_name

      def (self.ut).migration
        @migration ||= CustomMigration.new()
      end

      def (self.ut.migration).connection
        = (connection)
        @connection = connection
      end

      self.ut.migration.connection = self.ut.connection
      logger.debug "primary key on UT is #{self.ut.primary_key}"
    end
  rescue Exception => e
    logger.error "error in setup connection: " + e.message
  end
end

