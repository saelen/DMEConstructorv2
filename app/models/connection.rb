class Connection < ActiveRecord::Base
  attr_accessible :name, :adapter, :default_database, :host, :password, :username
  attr_accessor :uc

  validates_presence_of :adapter, :host

  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :password, presence: true
  validate :val_valid_connection

  before_save { |connection| connection.name = connection.name.upcase }
  before_save { |connection| connection.host = connection.host.downcase }
  before_save { |connection| connection.default_database = connection.default_database.upcase }

  after_initialize :setup_connection
  after_save :setup_connection
  after_update :setup_connection

  def test_connection
    begin
      @message = self.uc.connection.active?
    rescue => e
      {:success => false, :message => e.message}
    else
      {:success => true, :message => @message}
    end
  end

  private
  def val_valid_connection
    setup_connection
    @tc = test_connection
    if @tc[:false]
      errors.add(:base, 'Could not connect to database: ' + @tc[:message])
    end
  end

  def setup_connection
    self.uc = Class.new(ActiveRecord::Base)
    begin
      self.uc.establish_connection(
          :adapter => self.adapter,
          :host => self.host,
          :username => self.username,
          :password => self.password,
          :database => self.default_database)
    rescue Exception => e
      #We don't need to do anything with the exception
    end
  end
end
