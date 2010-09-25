$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'bell'
require 'spec'

class Spec::Example::ExampleGroup
  def execute(*args, &block)
    DB.transaction do
      super(*args, &block)
      raise Sequel::Error::Rollback
    end
  end
end
