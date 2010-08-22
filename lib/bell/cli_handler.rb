module Bell
  class CliHandler
    def initialize(messenger)
      @messenger = messenger
    end

    def run(args)
      case args.first
      when 'user' then UserHandler.new(@messenger).run(args[1..-1])
      else @messenger.puts OutputFormatter.usage
      end
    end
  end
end
