module Bell
  class CliHandler
    def initialize(messenger)
      @messenger = messenger
    end

    def handle!(args)
      case args.first
      when 'user' then
        begin
          UserHandler.new(@messenger).handle!(args[1..-1])
        rescue Errors::UserHandlerArgumentError
          @messenger.puts OutputFormatter.usage
        end
      when 'contact' then
        begin
          ContactHandler.new(@messenger).handle!(args[1..-1])
        rescue Errors::ContactHandlerArgumentError
          @messenger.puts OutputFormatter.usage
        end
      else
        raise Errors::CliHandlerArgumentError
      end
    end
  end
end
