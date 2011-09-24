require File.expand_path('../../lib/bell', __FILE__)

RSpec.configure do |config|
  config.around(:each) do |example|
    Sequel::DATABASES.first.transaction do
      example.run
      raise Sequel::Error::Rollback
    end
  end
end
