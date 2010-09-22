require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:runtime)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'bell/output_formatter'
require 'bell/cli_handler'
require 'bell/user_handler'
require 'bell/user_creator'
require 'bell/user_lister'
require 'bell/contact_handler'
require 'bell/contact_creator'
require 'bell/contact_lister'

require 'sequel'

if defined?(Spec) || defined?(Cucumber)
  DB = Sequel.sqlite
  DB.create_table :users do
    primary_key :id
    String :name, :unique => true, :null => false
  end
  DB.create_table :contacts do
    primary_key :id
    foreign_key :user_id, :null => false
    String :name, :null => false
    String :number, :unique => true, :null => false
  end
else
  Sequel.sqlite(File.join(File.dirname(__FILE__), '..', 'data', 'bell.db'))
end

require 'bell/user'
require 'bell/contact'

module Bell
  DIR_PATH = File.join(ENV['HOME'], '.bell')
  DB_PATH  = File.join(DIR_PATH, 'bell.db')

  USAGE = <<-USAGE.gsub(/^    /, '')
    bell te auxilia no controle de gastos de uma conta da embratel.

      Comandos:
      bell user create USER
      bell user list
      bell contact create CONTACT [-n|--number] NUMBER [-u|--user] USER
      bell contact list
      bell implode
  USAGE

  class << self
    def bootstrapped?
      dir_created? && database_created?
    end

    def dir_created?
      File.exists?(DIR_PATH)
    end

    def database_created?
      File.exists?(DB_PATH)
    end

    def create_tables?
      Sequel.sqlite(DB_PATH) do |database|
        database.create_table? :users do
          primary_key :id
          String :name, :unique => true, :null => false
        end
        database.create_table? :contacts do
          primary_key :id
          foreign_key :user_id, :null => false
          String :name, :null => false
          String :number, :unique => true, :null => false
        end
      end
    end

    def create_dir!
      FileUtils.mkdir(DIR_PATH)
    end

    def bootstrap!
      create_dir! and create_tables? unless dir_created?
    end

    def implode!
      [User, Contact].each(&:delete)
      FileUtils.rm_rf(DIR_PATH)
    end
  end
end
