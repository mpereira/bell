When /^I run bell with "([^"]*)"$/ do |args|
  @messenger = StringIO.new
  Bell::CliHandler.new(@messenger).run(args.split)
end

Then /^bell should show the usage$/ do
  @messenger.string.should == Bell::OutputFormatter.usage
end

Given /^no user named "([^"]*)" exists$/ do |user_name|
  user = Bell::User[:name => user_name]
  user.delete if user
end

Given /^the user named "([^"]*)" exists$/ do |user_name|
  Bell::User.create(:name => user_name)
end

Then /^bell should tell that the user "([^"]*)" was created$/ do |user_name|
  @messenger.string.should == Bell::OutputFormatter.user_created(user_name)
end

Then /^bell should tell that the user "([^"]*)" already exists$/ do |user_name|
  @messenger.string.should == Bell::OutputFormatter.user_exists(user_name)
end

Then /^I should have the user "([^"]*)" in the database$/ do |user_name|
  Bell::User[:name => user_name].should be_true
end

Then /^the messenger should contain "([^"]*)"$/ do |text|
  @messenger.string.should be_include(text)
end

Given /^no user exists$/ do
  Bell::User.delete
end
