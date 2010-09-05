Given /^a contact with name "([^"]*)" exists$/ do |contact_name|
  @contact = Bell::Contact.create(:name => contact_name, :number => random_number)
end

Given /^a contact with name "([^"]*)" and number "([^"]*)" exists$/ do |contact_name, contact_number|
  @contact = Bell::Contact.create(:name => contact_name, :number => contact_number)
end

Given /^"([^"]*)" has a contact with name "([^"]*)" in his contact list$/ do |user_name, contact_name|
  Given %{"#{user_name}" has a contact with name "#{contact_name}" and number "#{random_number}" in his contact list}
end

Given /^"([^"]*)" has a contact with name "([^"]*)" and number "([^"]*)" in his contact list$/ do |user_name, contact_name, contact_number|
  user = Bell::User.find(:name => user_name)
  if @contact
    user.add_contact(@contact)
  else
    user.add_contact(:name => contact_name, :number => contact_number)
  end
end

Given /^"([^"]*)" doesn't have a contact with name "([^"]*)" in his contacts$/ do |user_name, contact_name|
  user = Bell::User.find(:name => user_name)
  Bell::Contact.filter(:name => contact_name, :user_id => user.id).delete
end

Then /^bell should tell me that "([^"]*)" already has "([^"]*)" in his contact list$/ do |user_name, contact_name|
  user = Bell::User.find(:name => user_name)
  contact = Bell::Contact.find(:name => contact_name, :user_id => user.id)
  @messenger.string.should == Bell::OutputFormatter.contact_already_exists(contact)
end

Then /^bell should tell me that the contact "([^"]*)" was created for "([^"]*)"$/ do |contact_name, user_name|
  user = Bell::User.find(:name => user_name)
  contact = Bell::Contact.find(:name => contact_name, :user_id => user.id)
  @messenger.string.should == Bell::OutputFormatter.contact_created(contact)
end

Then /^"([^"]*)" should have "([^"]*)" in his contact list$/ do |user_name, contact_name|
  user = Bell::User.find(:name => user_name)
  Bell::Contact.find(:name => contact_name, :user_id => user.id).should_not be_nil
end

Then /^bell should tell me that the number "([^"]*)" was already taken$/ do |contact_number|
  contact = Bell::Contact.find(:number => contact_number)
  @messenger.string.should == Bell::OutputFormatter.contact_number_already_taken(contact)
end
