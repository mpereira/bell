module Bell
  class UserHandler
    def initialize(messenger)
      @messenger = messenger
    end

    def run(args)
      case args.first
      when 'create' then
        begin
          UserCreator.new(@messenger).run(args[1..-1])
        rescue Errors::UserCreatorArgumentError
          @messenger.puts OutputFormatter.usage
        end
      when 'list' then
        begin
          UserLister.new(@messenger).run(args[1..-1])
        rescue Errors::UserListerArgumentError
          @messenger.puts OutputFormatter.usage
        end
      else
        raise Errors::UserHandlerArgumentError
      end
    end
  end
end
