When /^I request a full report$/ do
  params = { :path => @path }
  Bell::Handlers::ReportsHandler.create(params)
end

When /^I request a full report for a non\-existing file$/ do
  @path = non_existing_file_path
  When %{I request a full report}
end

When /^I request a full report for a directory$/ do
  @path = directory_path
  When %{I request a full report}
end

When /^I request a full report for a non phone bill file$/ do
  @path = non_phone_bill_file_path
  When %{I request a full report}
end

When /^I request a full report for an invalid phone bill file$/ do
  @path = invalid_phone_bill_file_path
  When %{I request a full report}
end

When /^I request a full report for a valid phone bill file$/ do
  @path = valid_phone_bill_file_path
  When %{I request a full report}
end

Then /^bell should tell me that the path passed does not exist$/ do
  Bell.output.string.chomp.should == Bell::Message.no_such_file_or_directory(@path)
end

Then /^bell should tell me that the path passed is a directory$/ do
  Bell.output.string.chomp.should == Bell::Message.path_is_a_directory(@path)
end

Then /^bell should tell me that the path passed is a non phone bill file$/ do
  Bell.output.string.chomp.should == Bell::Message.invalid_phone_bill_file(@path)
end

Then /^bell should tell me that the path passed is an invalid phone bill$/ do
  Bell.output.string.chomp.should == Bell::Message.invalid_phone_bill_file(@path)
end
