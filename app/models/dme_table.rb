class DmeTable < ActiveRecord::Base
  attr_accessible :connection_id, :database_name, :display_name, :table_name
  attr_accessor :ut
  belongs_to :connection

  validates_presence_of :connection_id, :database_name, :display_name, :table_name
  validates_uniqueness_of :display_name

  after_initialize :setup_connection
  after_save :setup_connection
  after_update :setup_connection

  def setup_connection
    begin
      self.ut = Connection.find_by_id(self.connection_id).uc.clone
      self.ut.table_name = self.table_name
    rescue Exception => e
    end
  end
end
