When /^I run bell with "([^"]*)"$/ do |args|
  @messenger = StringIO.new
  Bell::CliHandler.new(@messenger).handle!(args.split)
end

Then /^bell should show the usage$/ do
  @messenger.string.should == Bell::USAGE
end

Then /^the messenger should contain "([^"]*)"$/ do |text|
  @messenger.string.should be_include(text)
end
