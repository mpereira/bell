When /^I run bell with "([^"]*)"$/ do |args|
  Bell::Cli.run(args.split)
end

Then /^bell should show the usage$/ do
  Bell.output.string.should == Bell::USAGE
end

Then /^the output should contain "([^"]*)"$/ do |text|
  Bell.output.string.should be_include(text)
end
