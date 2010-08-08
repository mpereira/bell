require 'rubygems'
require 'bundler'
Bundler.setup
require 'sequel'

DB = Sequel.sqlite(
  File.join(File.dirname(__FILE__), '..', '..', 'data', 'bell_test.db')
)

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'bell'
