require 'bundler'

begin
  Bundler.setup(:runtime, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'

require 'spec/rake/spectask'
desc "Run all specs"
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_files = FileList['spec/**/*.rb']
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features) do |features|
  features.cucumber_opts = "features --format progress"
end

require 'sequel'
namespace :db do
  desc "Creates and prepares the database"
  task :prepare do
    DB = Sequel.sqlite(File.join(File.dirname(__FILE__), 'data', 'bell.db'))
    begin
      DB.create_table :users do
        primary_key :id
        String :name
      end
    rescue Sequel::Error
      puts "A tabela para os usuários já foi criada"
    else
      puts "Tabela 'users' criada"
    end
    begin
      DB.create_table :contacts do
        primary_key :id
        foreign_key :user_id
        String :name
        String :phone
      end
    rescue Sequel::Error
      puts "A tabela para os contatos já foi criada"
    else
      puts "Tabela 'contacts' criada"
    end
  end

  desc "Drops the database"
  task :drop do
    FileUtils.rm_f(File.join(File.dirname(__FILE__), 'data', 'bell.db'))
  end
end

task :default => [:features, :spec]
