Given /^a clean slate$/ do
  DB.tables.each { |table| DB[table].delete }
end
