require 'spec/rake/spectask'
require 'cucumber/rake/task'

desc "Run RSpec specs"
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_opts  = %w[--backtrace --colour]
  t.spec_files = FileList['spec/**/*.rb']
end

Cucumber::Rake::Task.new(:features) do |features|
  features.cucumber_opts = "features --format progress"
end

task :default => [:spec, :features]
