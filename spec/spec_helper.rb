$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'rubygems'
require 'bell'
require 'spec'

unless defined?(FIXTURES_PATH)
  FIXTURES_PATH = File.join(File.dirname(__FILE__), 'fixtures')
end

Spec::Runner.configure do |config|
  config.suppress_deprecation_warnings!
end

class Spec::Example::ExampleGroup
  def execute(*args, &block)
    DB.transaction do
      super(*args, &block)
      raise Sequel::Error::Rollback
    end
    true
  end
end
