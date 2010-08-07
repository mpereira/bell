$:.unshift File.join(File.dirname(__FILE__), '..', '..', 'lib')
require 'aruba'
require 'bell'
require 'fileutils'
require 'sequel'

TEST_DIR = File.join('/', 'tmp', 'bell')
ENV['PATH'] += ":#{File.join(File.dirname(__FILE__), '..', '..', 'bin')}"
