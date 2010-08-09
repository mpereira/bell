$:.unshift File.join(File.dirname(__FILE__), '..', '..', 'lib')
require 'aruba'
require 'bell'
require 'spec/stubs/cucumber'

ENV['PATH'] += ":#{File.join(File.dirname(__FILE__), '..', '..', 'bin')}"
