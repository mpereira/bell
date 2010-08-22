When /^I run bell with "([^"]*)"$/ do |args|
  @messenger = StringIO.new
  Bell::CliHandler.new(@messenger).run(args.split)
end

Then /^bell should show the usage$/ do
  @messenger.string.should == Bell::OutputFormatter.usage
end

Then /^the messenger should contain "([^"]*)"$/ do |text|
  @messenger.string.should be_include(text)
end
