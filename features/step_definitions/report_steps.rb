When /^I request a full report$/ do
  params = { :path => @path }
  Bell::Handlers::ReportsHandler.show(params)
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
