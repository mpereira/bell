Given /^no contact named "([^"]*)" exists$/ do |contact_name|
  contact = Bell::Contact[:name => contact_name]
  contact.delete if contact
end

Then /^the contact "([^"]*)" should belong to "([^"]*)"$/ do |contact_name, user_name|
  Bell::Contact[:name => contact_name].user.should == Bell::User[:name => user_name]
end

Then /^bell should tell me that the contact "([^"]*)" was created$/ do |contact_name|
  contact = Bell::Contact[:name => contact_name]
  @messenger.string.should == Bell::OutputFormatter.contact_created(contact)
end

Then /^I should have the contact "([^"]*)" in the database$/ do |contact_name|
  Bell::Contact[:name => contact_name].should be_true
end
