module Bell
  class CliHandler
    def initialize(messenger)
      @messenger = messenger
    end

    def handle!(args)
      case args.first
      when 'user' then UserHandler.new(@messenger).handle!(args[1..-1])
      when 'contact' then ContactHandler.new(@messenger).handle!(args[1..-1])
      else raise Errors::CliHandlerArgumentError
      end
    rescue Errors::UserHandlerArgumentError
      @messenger.puts USAGE
    rescue Errors::ContactHandlerArgumentError
      @messenger.puts USAGE
    end
  end
end
