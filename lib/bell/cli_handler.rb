module Bell
  class CliHandler
    def initialize(messenger)
      @messenger = messenger
    end

    def handle!(args)
      case args.first
      when 'user' then UserHandler.new(@messenger).handle!(args[1..-1])
      when 'contact' then ContactHandler.new(@messenger).handle!(args[1..-1])
      else @messenger.puts USAGE
      end
    end
  end
end
