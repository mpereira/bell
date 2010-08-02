$:.unshift File.join(File.dirname(__FILE__), '..', '..', 'lib')
require 'bell'
require 'aruba'

ENV['PATH'] += ":#{File.join(File.dirname(__FILE__), '..', '..', 'bin')}"
