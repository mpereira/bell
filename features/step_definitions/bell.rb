Before do
  FileUtils.mkdir_p(File.join(TEST_DIR, 'data'))
  Dir.chdir(TEST_DIR)
end

After do
  Dir.chdir(TEST_DIR)
  FileUtils.rm_rf(TEST_DIR)
end

Given /^no user named "([^"]*)" exists$/ do |user_name|
  FileUtils.rm_rf(File.join(TEST_DIR, "#{user_name}.yml"))
end

Then /^I should have the file "([^"]*)" on the database$/ do |file_name|
end
