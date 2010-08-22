module Bell
  class UserHandler
    def initialize(messenger)
      @messenger = messenger
    end

    def run(args)
      case args.first
      when 'create' then UserCreator.new(@messenger).run(args[1..-1])
      else @messenger.puts Messenger.show_usage
      end
    end
  end
end
