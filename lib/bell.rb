%w[embratel sequel sqlite3].each do |gem|
  begin
    require gem
  rescue LoadError
    $stderr.puts $!
    exit 1
  end
end

require 'fileutils'

require 'bell/util'
require 'bell/message'
require 'bell/displayable'

require 'bell/commands'
require 'bell/dispatcher'
require 'bell/cli'

require 'bell/csv_parser'
require 'bell/handlers'

require 'bell/full_report'
require 'bell/user_report'

module Bell
  extend self

  class InvalidContacts < StandardError; end

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

  def output
    @output ||= Output.new
  end

  class Output
    def initialize
      @outputter = Bell.testing? ? StringIO.new : $stdout
    end

    def puts(text)
      @outputter.puts(text)
    end

    def string
      @outputter.string
    end

    def reopen
      @outputter.reopen if Bell.testing?
    end
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
        database.create_table?(:users) do
          primary_key :id
          String :name, :unique => true, :null => false
        end
        database.create_table?(:contacts) do
          primary_key :id
          foreign_key :user_id, :null => false
          String :name, :null => false
          String :number, :unique => true, :null => false
        end
        database.create_table?(:public_contacts) do
          primary_key :id
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
require 'bell/public_contact'

if RUBY_VERSION < '1.9'
  require 'fastercsv'
  Bell::CSV = FasterCSV
  require 'jcode'
  $KCODE = "UTF8"
else
  require 'csv'
  Bell::CSV = CSV
end
