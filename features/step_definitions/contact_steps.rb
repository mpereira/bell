Given /^no contact named "([^"]*)" exists$/ do |contact_name|
  Bell::Contact.find(:name => contact_name).delete
end

Given /^the contact named "([^"]*)" exists$/ do |contact_name|
  Bell::Contact.create(:name => contact_name)
end

Given /^"([^"]*)" has "([^"]*)" in his contacts$/ do |user_name, contact_name|
  user = Bell::User.find(:name => user_name)
  contact = Bell::Contact.find_or_create(:name => contact_name)
  user.add_contact(contact)
end

Given /^"([^"]*)" doesn't have "([^"]*)" in his contacts$/ do |user_name, contact_name|
  user = Bell::User.find(:name => user_name)
  Bell::Contact.find(:name => contact_name, :user_id => user.id).delete
end

Then /^bell should tell me that "([^"]*)" already has "([^"]*)" in his contacts$/ do |user_name, contact_name|
  user = Bell::User.find(:name => user_name)
  contact = Bell::Contact.find(:name => contact_name, :user_id => user.id)
  @messenger.string.should == Bell::OutputFormatter.contact_exists(contact_name)
end

Then /^bell should tell me that the contact "([^"]*)" was created for "([^"]*)"$/ do |contact_name, user_name|
  user = Bell::User.find(:name => user_name)
  contact = Bell::Contact.find(:name => contact_name, :user_id => user.id)
  @messenger.string.should == Bell::OutputFormatter.contact_created(contact)
end

Then /^"([^"]*)" should have the contact "([^"]*)" in his database$/ do |user_name, contact_name|
  user = Bell::User.find(:name => user_name)
  user.contacts.find(:name => contact_name).should_not be_nil
end
