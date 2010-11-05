When /^I request a full report using "([^"]*)"$/ do |path|
  path = File.join(TMP_PATH, path)
  params = { :path => path }
  Bell::Handlers::ReportsHandler.full_report(params)
end

When /^I request a user report using "([^"]*)"$/ do |path|
  path = File.join(TMP_PATH, path)
  params = { :path => path }
  Bell::Handlers::ReportsHandler.user_report(params)
end

When /^I request a user report for "([^"]*)" using "([^"]*)"$/ do |user_name, path|
  path = File.join(TMP_PATH, path)
  params = { :path => path, :user => { :name => user_name } }
  Bell::Handlers::ReportsHandler.user_report(params)
end
