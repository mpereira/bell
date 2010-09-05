$:.unshift File.join(File.dirname(__FILE__), '..', '..', 'lib')
require 'aruba'
require 'bell'
require 'spec/stubs/cucumber'

Before('@no-txn') do
  Given 'a clean slate'
end

After('@no-txn') do
  Given 'a clean slate'
end

module Bell::StepDefinitionHelper
  def random_number
    charset = %w[0 1 2 3 4 5 6 7 9]
    (0...10).map{ charset.to_a[rand(charset.size)] }.join
  end
end

World(Bell::StepDefinitionHelper)
