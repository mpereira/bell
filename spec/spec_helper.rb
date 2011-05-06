require File.expand_path('../../lib/bell', __FILE__)
require 'spec'

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
