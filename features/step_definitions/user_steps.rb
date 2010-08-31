Given /^no user named "([^"]*)" exists$/ do |user_name|
  Bell::User.filter(:name => user_name).delete
end

Given /^the user named "([^"]*)" exists$/ do |user_name|
  Bell::User.find_or_create(:name => user_name)
end

Then /^bell should tell that the user "([^"]*)" was created$/ do |user_name|
  @messenger.string.should == Bell::OutputFormatter.user_created(user_name)
end

Then /^bell should tell that the user "([^"]*)" already exists$/ do |user_name|
  @messenger.string.should == Bell::OutputFormatter.user_exists(user_name)
end

Then /^bell should tell that the user "([^"]*)" doesn't exist$/ do |user_name|
  @messenger.string.should == Bell::OutputFormatter.user_does_not_exist(user_name)
end

Then /^I should have the user "([^"]*)" in the database$/ do |user_name|
  Bell::User.find(:name => user_name).should_not be_nil
end

Given /^no user exists$/ do
  Bell::User.delete
end
