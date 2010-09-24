begin
  require 'bundler'
rescue LoadError
  STDERR.puts "You need to install bundler"
  exit 1
else
  begin
    Bundler.setup(:development)
  rescue Bundler::BundlerError
    STDERR.puts $!
    exit 1
  end
end

require 'spec/rake/spectask'
desc "Run all specs"
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_opts  = %w[--backtrace --colour]
  t.spec_files = FileList['spec/**/*.rb']
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features) do |features|
  features.cucumber_opts = "features --format progress"
end

task :default => [:features, :spec]
