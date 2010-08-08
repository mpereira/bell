require 'rake'
require 'spec/rake/spectask'

desc "Run all examples"
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_files = FileList['spec/**/*.rb']
end

namespace :db do
  desc "Prepare database"
  task :prepare do
    require 'rubygems'
    require 'bundler'
    Bundler.setup
    require 'sequel'

    BELL_ENV = ENV['BELL_ENV']

    DATABASE = BELL_ENV ? "bell_#{BELL_ENV}.db" : 'bell.db'
    DATABASE_PATH = File.join(File.dirname(__FILE__), 'data')

    DB = Sequel.connect("sqlite://#{File.join(DATABASE_PATH, DATABASE)}")

    if File.exist?(File.join(DATABASE_PATH, DATABASE))
      $stderr.puts "O banco de dados já foi criado anteriormente"
    else
      DB.create_table :users do
        primary_key :id
        String :name, :unique => true, :null => false
      end
      $stdout.puts "Banco de dados criado com sucesso"
    end
  end
end
