$:.unshift File.join(File.dirname(__FILE__), '..', '..', 'lib')
require 'bell'
require 'spec/stubs/cucumber'

Before('@no-txn') do
  Given 'a clean slate'
end

After('@no-txn') do
  Given 'a clean slate'
end

module Bell::StepDefinitionHelper
  FIXTURES_PATH = File.join(File.dirname(__FILE__), '..', '..', 'spec', 'fixtures')

  def non_existing_file_path
    "#{FIXTURES_PATH}/non_existing_file.csv"
  end

  def directory_path
    "#{FIXTURES_PATH}"
  end

  def non_phone_bill_file_path
    "#{FIXTURES_PATH}/text_file.txt"
  end

  def invalid_phone_bill_file_path
    "#{FIXTURES_PATH}/invalid_phone_bill_file.csv"
  end

  def valid_phone_bill_file_path
    "#{FIXTURES_PATH}/valid_phone_bill_file.csv"
  end

  def random_name
    (0...8).map{65.+(rand(25)).chr}.join
  end

  def random_number
    charset = %w[0 1 2 3 4 5 6 7 9]
    (0...10).map{ charset.to_a[rand(charset.size)] }.join
  end
end

World(Bell::StepDefinitionHelper)
