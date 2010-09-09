Given /^a contact with name "([^"]*)" and number "([^"]*)" exists$/ do |contact_name, contact_number|
  Bell::Contact.create(:name => contact_name, :number => contact_number)
end

Given /^a contact with name "([^"]*)" exists$/ do |contact_name|
  Given %{a contact with name "#{contact_name}" and number "#{random_number}" exists}
end

Given /^"([^"]*)" has a contact with name "([^"]*)" and number "([^"]*)" in his contact list$/ do |user_name, contact_name, contact_number|
  user = Bell::User.find(:name => user_name)
  user.add_contact(:name => contact_name, :number => contact_number)
end

Given /^"([^"]*)" has a contact with name "([^"]*)" in his contact list$/ do |user_name, contact_name|
  Given %{"#{user_name}" has a contact with name "#{contact_name}" and number "#{random_number}" in his contact list}
end

Given /^"([^"]*)" doesn't have a contact with name "([^"]*)" in his contacts$/ do |user_name, contact_name|
  user = Bell::User.find(:name => user_name)
  Bell::Contact.filter(:name => contact_name, :user_id => user.id).delete
end

When /^I create a contact with name "([^"]*)" for the user with name "([^"]*)"$/ do |contact_name, user_name|
  Given %{I create a contact with name "#{contact_name}" and with number "#{random_number}" for the user with name "#{user_name}"}
end

When /^I create a contact with name "([^"]*)" and with number "([^"]*)" for the user with name "([^"]*)"$/ do |contact_name, contact_number, user_name|
  @messenger = StringIO.new
  Bell::ContactCreator.new(@messenger).create!(
    {
      :user => { :name => user_name },
      :contact => { :name => contact_name, :number => contact_number }
    }
  )
end

When /^I list all contacts$/ do
  @messenger = StringIO.new
  Bell::ContactLister.new(@messenger).list!
end

When /^I list the contacts for the user with name "([^"]*)"$/ do |user_name|
  @messenger = StringIO.new
  Bell::ContactLister.new(@messenger).list!([user_name])
end

Then /^bell should tell me that "([^"]*)" already has "([^"]*)" in his contact list$/ do |user_name, contact_name|
  user = Bell::User.find(:name => user_name)
  contact = Bell::Contact.find(:name => contact_name, :user_id => user.id)
  Bell::OutputFormatter.contact_name_taken(contact.name).should ==
    Bell::OutputFormatter.contact_name_taken(contact_name)
  @messenger.string.chomp.should == Bell::OutputFormatter.contact_name_taken(contact_name)
end

Then /^bell should tell me that the contact "([^"]*)" was created for "([^"]*)"$/ do |contact_name, user_name|
  user = Bell::User.find(:name => user_name)
  contact = Bell::Contact.find(:name => contact_name, :user_id => user.id)
  @messenger.string.chomp.should == Bell::OutputFormatter.contact_created(contact)
end

Then /^"([^"]*)" should have "([^"]*)" in his contact list$/ do |user_name, contact_name|
  user = Bell::User.find(:name => user_name)
  Bell::Contact.find(:name => contact_name, :user_id => user.id).should_not be_nil
end

Then /^bell should tell me that the number "([^"]*)" was already taken$/ do |contact_number|
  @messenger.string.chomp.should == Bell::OutputFormatter.contact_number_taken(contact_number)
end

Then /^bell should tell me that the number "([^"]*)" has a bad format$/ do |contact_number|
  @messenger.string.chomp.should == Bell::OutputFormatter.bad_format_for_contact_number(contact_number)
end
