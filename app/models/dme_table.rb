class DmeTable < ActiveRecord::Base
  attr_accessible :connection_id, :database_name, :display_name, :table_name

  belongs_to :connection
  validates_presence_of :connection_id, :database_name, :display_name, :table_name

  validates_uniqueness_of :display_name

end
