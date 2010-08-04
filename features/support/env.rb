$:.unshift File.join(File.dirname(__FILE__), '..', '..', 'lib')
require 'bell'
require 'aruba'
require 'fileutils'

TEST_DIR = File.join('/', 'tmp', 'bell')
ENV['PATH'] += ":#{File.join(File.dirname(__FILE__), '..', '..', 'bin')}"
