require 'bundler'
Bundler::GemHelper.install_tasks

require 'spec/rake/spectask'
desc "Run RSpec specs"
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_opts  = %w[--backtrace --colour]
  t.spec_files = FileList['spec/**/*.rb']
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features) do |features|
  features.cucumber_opts = "features --format progress"
end

task :default => [:spec, :features]
