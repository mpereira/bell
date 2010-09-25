$:.unshift File.join(File.dirname(__FILE__), '..', '..', 'lib')
require 'bell'
require 'spec/stubs/cucumber'

Before('@no-txn') do
  Given 'a clean slate'
end

After('@no-txn') do
  Given 'a clean slate'
end

module Bell::ContactStepDefinitionHelper
  def random_name
    (0...8).map{65.+(rand(25)).chr}.join
  end

  def random_number
    charset = %w[0 1 2 3 4 5 6 7 9]
    (0...10).map{ charset.to_a[rand(charset.size)] }.join
  end
end

World(Bell::ContactStepDefinitionHelper)
