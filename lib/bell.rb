require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:runtime)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'bell/output_formatter'
require 'bell/cli_handler'
require 'bell/user_handler'
require 'bell/user_creator'
require 'bell/user_lister'
require 'bell/contact_handler'
require 'bell/contact_creator'
require 'bell/contact_lister'

require 'sequel'

if defined?(Spec) || defined?(Cucumber)
  DB = Sequel.sqlite
  DB.create_table :users do
    primary_key :id
    String :name
  end
  DB.create_table :contacts do
    primary_key :id
    foreign_key :user_id
    String :name
    String :phone
  end
else
  DB = Sequel.sqlite(File.join(File.dirname(__FILE__), '..', 'data', 'bell.db'))
end

require 'bell/user'
require 'bell/contact'
