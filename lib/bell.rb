%w[embratel sequel sqlite3].each do |gem|
  begin
    require gem
  rescue LoadError
    $stderr.puts $!
    exit 1
  end
end

require 'bell/util'
require 'bell/message'
require 'bell/displayable'

require 'bell/command'
require 'bell/dispatcher'
require 'bell/cli'

require 'bell/users_handler'
require 'bell/contacts_handler'
require 'bell/reports_handler'

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

  extend self

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

  module Directory
    extend self

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
require 'bell/report'
