require "rubygems"
require "active_record"
# Use the following line instead (without the comment hash) if you are using JRuby
#require "active_record"

#Now define your classes from the database as always

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
end
mytable = UserTable.new('asdf')

mytable.utar.where({ :col1  => ['from ruby!']}).limit(1).each do |row|
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

