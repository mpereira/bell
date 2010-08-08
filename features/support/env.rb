require 'rubygems'
require 'bundler'
Bundler.setup
require 'aruba'
require 'sequel'

DB = Sequel.sqlite(
  File.join(File.dirname(__FILE__), '..', '..', 'data', 'bell.db')
)

$:.unshift File.join(File.dirname(__FILE__), '..', '..', 'lib')
require 'bell'

ENV['PATH'] += ":#{File.join(File.dirname(__FILE__), '..', '..', 'bin')}"

at_exit do
end
