require 'rubygems'

begin
  require 'bundler'
rescue LoadError
  STDERR.puts "You need to install bundler"
  exit 1
else
  begin
    Bundler.setup(:runtime)
  rescue Bundler::BundlerError
    STDERR.puts $!
    exit 1
  end
end

require 'bell/message'
require 'bell/displayable'
require 'bell/cli'
require 'bell/command'
require 'bell/util'
require 'bell/dispatcher'
require 'bell/users_handler'
require 'bell/contacts_handler'
require 'bell/reports_handler'
require 'bell/report'

require 'embratel'

require 'sequel'

module Bell
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
    def testing?
      defined?(Spec) || defined?(Cucumber)
    end

    def environment
      testing? ? 'test' : 'runtime'
    end

    def database
      @database ||= Database.new(:environment => environment)
    end

    def database_connection
      @database_connection ||= database.connect
    end

    def bootstrapped?
      Directory.created? && database.created?
    end

    def bootstrap
      Directory.create unless Directory.created?
      database.create_tables?
    end

    def implode!
      [User, Contact].each(&:delete)
      FileUtils.rm_rf(Directory.path)
    end
  end

  module Directory
    class << self
      def path
        File.join(ENV['HOME'], '.bell')
      end

      def created?
        File.exists?(path)
      end

      def create
        FileUtils.mkdir(path)
      end
    end
  end

  class Database
    def initialize(options = {})
      @environment = options[:environment]
    end

    def path
      File.join(Directory.path, "bell_#{@environment}.db")
    end

    def created?
      File.exists?(path)
    end

    def create_tables?
      Sequel.sqlite(path) do |database|
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

    def connect
      Sequel.sqlite(path)
    end
  end
end

DB = Bell.database_connection
Bell.bootstrap unless Bell.bootstrapped?

require 'bell/user'
require 'bell/contact'
