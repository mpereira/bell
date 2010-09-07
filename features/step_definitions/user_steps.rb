Given /^no user exists$/ do
  Bell::User.delete
end

Given /^no user with name "([^"]*)" exists$/ do |user_name|
  Bell::User.filter(:name => user_name).delete
end

Given /^a user with name "([^"]*)" exists$/ do |user_name|
  Bell::User.create(:name => user_name)
end

When /^I create a user with name "([^"]*)"$/ do |user_name|
  @messenger = StringIO.new
  Bell::UserCreator.new(@messenger).create!([user_name])
end

When /^I list the users$/ do
  @messenger = StringIO.new
  Bell::UserLister.new(@messenger).list!
end

Then /^bell should tell me that there are no created users$/ do
  @messenger.string.chomp.should == Bell::OutputFormatter.no_created_users
end

Then /^bell should tell me that a user with name "([^"]*)" was created$/ do |user_name|
  @messenger.string.chomp.should == Bell::OutputFormatter.user_created(user_name)
end

Then /^bell should tell me that the user "([^"]*)" already exists$/ do |user_name|
  @messenger.string.chomp.should == Bell::OutputFormatter.user_already_exists(user_name)
end

Then /^bell should tell me that there is no user with name "([^"]*)"$/ do |user_name|
  @messenger.string.chomp.should == Bell::OutputFormatter.user_does_not_exist(user_name)
end

Then /^I should have the user "([^"]*)" in the database$/ do |user_name|
  Bell::User.find(:name => user_name).should_not be_nil
end
