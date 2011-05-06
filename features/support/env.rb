require File.expand_path('../../../lib/bell', __FILE__)

TMP_PATH = File.path('/tmp/bell')
FIXTURES_PATH = File.expand_path('../../../spec/fixtures', __FILE__)

After('@no-txn') do
  Given 'a clean slate'
end

Before do
  Bell.output.reopen
  FileUtils.rm_rf(TMP_PATH)
  FileUtils.mkdir_p(TMP_PATH)
end

at_exit do
  FileUtils.rm_rf(TMP_PATH)
end

module Bell::StepDefinitionHelper
  def inside_tmp_directory(&block)
    FileUtils.chdir(TMP_PATH, &block)
  end

  def non_existing_file_path
    "#{FIXTURES_PATH}/non_existing_file.csv"
  end

  def directory_path
    "#{FIXTURES_PATH}"
  end

  def non_phone_bill_file_path
    "#{FIXTURES_PATH}/text_file.txt"
  end

  def malformed_csv_file_path
    "#{FIXTURES_PATH}/malformed_csv_file.csv"
  end

  def valid_phone_bill_file_path
    "#{FIXTURES_PATH}/valid_phone_bill_file.csv"
  end

  def invalid_contacts_file_path
    "#{FIXTURES_PATH}/invalid_contacts_file.csv"
  end

  def valid_contacts_file_path
    "#{FIXTURES_PATH}/valid_contacts_file.csv"
  end

  def random_name
    (0...8).map { (65 + (rand(25))).chr }.join
  end

  def random_number
    charset = %w[0 1 2 3 4 5 6 7 9]
    (0...10).map { charset.to_a[rand(charset.size)] }.join
  end
end

World(Bell::StepDefinitionHelper)
