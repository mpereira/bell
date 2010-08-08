Given /^no user named "([^"]*)" exists$/ do |user_name|
  user = Bell::User[:name => user_name]
  user.delete if user
end

Then /^I should have the user "([^"]*)" in the database$/ do |user_name|
  Bell::User[:name => user_name].should be_true
end
