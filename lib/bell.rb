require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:runtime)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'bell/messenger'
require 'bell/cli_handler'
require 'bell/user_handler'
require 'bell/user_creator'

require 'sequel'

if defined?(Spec) || defined?(Cucumber)
  DB = Sequel.sqlite
  DB.create_table :users do
    primary_key :id
    String :name
  end
else
  DB = Sequel.sqlite(File.join(File.dirname(__FILE__), '..', 'data', 'bell.db'))
end

require 'bell/user'
