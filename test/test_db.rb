require "rubygems"
require "active_record"

class UserTable
  attr_accessor :utar

  def initialize(tablename)
    @utar = Class.new(ActiveRecord::Base)
    @utar.establish_connection(
        :adapter => "sqlserver",
        :host => "localhost",
        :username => "dmeadmin",
        :password => "admin",
        :database => "DMECentral")
    @utar.table_name = tablename
  end

  def testconnection
    begin
      @message = @utar.connection.active?
    rescue => e
      {:success => false, :message => e.message}
    else
      {:success => true, :message => @message}
    end
  end
end
mytable = UserTable.new('asdf')
@testconnectionresults = mytable.testconnection
if @testconnectionresults[:success]
  puts 'Success'
else
  puts @testconnectionresults[:message]
end
exit(1)

mytable.utar.where({:col1 => ['from ruby!']}).limit(1).each do |row|
  puts row.inspect
  row['col1'] = 'AA'
  row.save!
end

#mytable.utar.create(:col1 => 'from ruby!')

class CustomMigration < ActiveRecord::Migration
  def up
    add_column 'mark_tests', 'col2', :string
  end

  def down
    remove_column 'mark_tests', 'col2'
  end
end

