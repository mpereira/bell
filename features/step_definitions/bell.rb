Before do
  FileUtils.mkdir_p(File.join(TEST_DIR, 'data'))
  Dir.chdir(TEST_DIR)
end

After do
  Dir.chdir(TEST_DIR)
  FileUtils.rm_rf(TEST_DIR)
end
