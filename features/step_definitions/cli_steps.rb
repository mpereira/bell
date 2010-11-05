Given /^a directory named "([^"]*)"$/ do |name|
  inside_the_tmp_directory do
    FileUtils.mkdir(name)
  end
end

Given /^a file named "([^"]*)" with:$/ do |file, content|
  inside_the_tmp_directory do
    file = File.new(file, 'w+') << content
    file.flush
  end
end

When /^I run bell with "([^"]*)"$/ do |args|
  Bell::Cli.run(args.split)
end

Then /^bell should tell me that the path passed does not exist$/ do
  Bell.output.string.chomp.should == Bell::Message.no_such_file_or_directory(@path)
end

Then /^bell should tell me that the path passed is a directory$/ do
  Bell.output.string.chomp.should == Bell::Message.path_is_a_directory(@path)
end

Then /^bell should tell me that the path passed is a non phone bill file$/ do
  Bell.output.string.chomp.should == Bell::Message.invalid_phone_bill_file(@path)
end

Then /^bell should tell me that the path passed is an invalid phone bill$/ do
  Bell.output.string.chomp.should == Bell::Message.invalid_phone_bill_file(@path)
end

Then /^bell should tell me that the path passed is an invalid contacts file$/ do
  Bell.output.string.chomp.should == Bell::Message.invalid_contacts_file(@path)
end

Then /^bell should tell me that "([^"]*)" does not exist$/ do |path|
  path = File.join(TMP_PATH, path)
  Bell.output.string.chomp.should == Bell::Message.no_such_file_or_directory(path)
end

Then /^bell should tell me that "([^"]*)" is a directory$/ do |path|
  path = File.join(TMP_PATH, path)
  Bell.output.string.chomp.should == Bell::Message.path_is_a_directory(path)
end

Then /^bell should tell me that "([^"]*)" is an invalid contacts file$/ do |path|
  path = File.join(TMP_PATH, path)
  Bell.output.string.chomp.should == Bell::Message.invalid_contacts_file(path)
end

Then /^bell's output should contain "(.*)"$/ do |text|
  Bell.output.string.should be_include(text)
end

Then /^bell's output should contain \/(.*)\/$/ do |text|
  Bell.output.string.should be_include(text)
end

Then /^the output should be "([^"]*)"$/ do |text|
  Bell.output.string.chomp.should  == text
end

Then /^the output should be:$/ do |text|
  Then %{the output should be "#{text}"}
end
