When /^I request a full report using "([^"]*)"$/ do |path|
  path = File.join(TMP_PATH, path)
  params = { :path => path }
  Bell::Handlers::ReportsHandler.full_report(params)
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

When /^I request a user report$/ do
  params = { :path => @path }
  Bell::Handlers::ReportsHandler.user_report(params)
end

When /^I request a user report for a non\-existing file$/ do
  @path = non_existing_file_path
  When %{I request a user report}
end

When /^I request a user report for a directory$/ do
  @path = directory_path
  When %{I request a user report}
end

When /^I request a user report for a non phone bill file$/ do
  @path = non_phone_bill_file_path
  When %{I request a user report}
end

When /^I request a user report for an invalid phone bill file$/ do
  @path = invalid_phone_bill_file_path
  When %{I request a user report}
end

When /^I request a user report for a valid phone bill file$/ do
  @path = valid_phone_bill_file_path
  When %{I request a user report}
end
