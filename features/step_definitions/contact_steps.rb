Given /^a contact with name "([^"]*)" and number "([^"]*)" exists$/ do |contact_name, contact_number|
  Bell::Contact.create(:name => contact_name, :number => contact_number)
end

Given /^a contact with name "([^"]*)" exists$/ do |contact_name|
  Given %{"#{random_name}" has a contact with name "#{contact_name}" and number "#{random_number}" in his contact list}
end

Given /^"([^"]*)" has a contact with name "([^"]*)" and number "([^"]*)" in his contact list$/ do |user_name, contact_name, contact_number|
  user = Bell::User.find_or_create(:name => user_name)
  user.add_contact(:name => contact_name, :number => contact_number)
end

Given /^"([^"]*)" has a contact with name "([^"]*)" in his contact list$/ do |user_name, contact_name|
  Given %{"#{user_name}" has a contact with name "#{contact_name}" and number "#{random_number}" in his contact list}
end

Given /^"([^"]*)" has a contact with number "([^"]*)" in his contact list$/ do |user_name, contact_number|
  Given %{"#{user_name}" has a contact with name "#{random_name}" and number "#{contact_number}" in his contact list}
end

Given /^"([^"]*)" doesn't have a contact with name "([^"]*)" in his contacts$/ do |user_name, contact_name|
  user = Bell::User.find(:name => user_name)
  Bell::Contact.filter(:name => contact_name, :user_id => user.id).delete
end

Given /^no contact with name "([^"]*)" exists$/ do |contact_name|
  Bell::Contact.filter(:name => contact_name).delete
end

Given /^no created contacts$/ do
  Bell::Contact.delete
end

When /^I list all contacts$/ do
  Bell::Handlers::ContactsHandler.list
end

When /^I list the contacts for the user with name "([^"]*)"$/ do |user_name|
  params = { :user => { :name => user_name }, :csv => @csv }
  Bell::Handlers::ContactsHandler.list(params)
end

When /^I list the contacts for the user with name "([^"]*)" in CSV format$/ do |user_name|
  @csv = true
  When %{I list the contacts for the user with name "#{user_name}"}
end

When /^I request a contact import using "([^"]*)"$/ do |path|
  Bell::Handlers::ContactsHandler.import(@params || { :path => File.join(TMP_PATH, path) })
end

When /^I request a contact import for "([^"]*)" using "([^"]*)"$/ do |user_name, path|
  @params = { :path => File.join(TMP_PATH, path), :user => { :name => user_name } }
  When %{I request a contact import using "#{path}"}
end

When /^I request a public contact import using "([^"]*)"$/ do |path|
  @params = { :path => File.join(TMP_PATH, path), :public => true }
  When %{I request a contact import using "#{path}"}
end

Then /^bell should tell me that "([^"]*)" already has "([^"]*)" in his contact list$/ do |user_name, contact_name|
  user = Bell::User.find(:name => user_name)
  contact = Bell::Contact.find(:name => contact_name, :user_id => user.id)
  Bell.output.string.chomp.should == Bell::Message.contact_name_taken(contact_name)
end

Then /^"([^"]*)" should have "([^"]*)" in his contact list$/ do |user_name, contact_name|
  user = Bell::User.find(:name => user_name)
  Bell::Contact.find(:name => contact_name, :user_id => user.id).should_not be_nil
end

Then /^"([^"]*)" should be in the public contact list$/ do |contact_name|
  Bell::PublicContact.find(:name => contact_name).should_not be_nil
end

Then /^bell should tell me that the number "([^"]*)" was already taken$/ do |contact_number|
  Bell.output.string.chomp.should == Bell::Message.contact_number_taken(contact_number)
end

Then /^bell should tell me that the number "([^"]*)" has a bad format$/ do |contact_number|
  Bell.output.string.chomp.should == Bell::Message.contact_number_bad_format(contact_number)
end

Then /^bell should tell me that the contact list of the user with name "([^"]*)" is empty$/ do |user_name|
  Bell.output.string.chomp.should == Bell::Message.contact_list_empty(user_name)
end

Then /^I should not have a contact with name "([^"]*)" in the database$/ do |contact_name|
  Bell::Contact.find(:name => contact_name).should be_nil
end

Then /^bell should tell me that the contact "([^"]*)" was removed$/ do |contact_name|
  Bell.output.string.chomp.should == Bell::Message.contact_removed(contact_name)
end

Then /^bell should tell me that there are no created contacts$/ do
  Bell.output.string.chomp.should == Bell::Message.no_contacts_created
end
