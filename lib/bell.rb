require 'fileutils'

module Bell
  USAGE = <<-USAGE
bell te auxilia no controle de gastos de uma conta da embratel.

Comandos:
  bell user create <USER>
  USAGE

  class Messenger
    def notify_user_existence(name)
      $stdout.puts "./data/#{name}.yml já existe"
    end

    def notify_user_creation(name)
      $stdout.puts "./data/#{name}.yml criado"
    end
  end

  class User
    DATA_PATH = File.join(File.dirname(__FILE__), '..', 'data')

    attr_reader :name

    def initialize(name)
      @name = name
    end

    def data_file
      File.join(DATA_PATH, "#{name}.yml")
    end

    def exists?
      File.exists?(data_file)
    end

    def create
      FileUtils.touch(data_file)
    end
  end

  class UserHandler
    attr_reader :action, :args

    def initialize(args)
      @action = args.first
      @args = args[1..-1]
    end

    def available_actions
      %w[create]
    end

    def valid_action?
      available_actions.include?(action)
    end

    def run
      if valid_action?
        case action
        when 'create' then UserCreator.new(args).run
        end
      else
        $stdout.puts Bell::USAGE
      end
    end
  end

  class UserCreator
    attr_reader :args, :messenger

    def initialize(args)
      @args = args
      @messenger = Messenger.new
    end

    def run
      if args.length == 1
        user = User.new(args)
        if user.exists?
          messenger.notify_user_existence(user.name)
        else
          user.create
          messenger.notify_user_creation(user.name)
        end
      else
        $stdout.puts USAGE
      end
    end
  end
end
