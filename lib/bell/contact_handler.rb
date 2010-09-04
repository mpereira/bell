module Bell
  class ContactHandler
    def initialize(messenger)
      @messenger = messenger
    end

    def handle!(args)
      case args.first
      when 'create' then
        begin
          ContactCreator.new(@messenger).create!(args[1..-1])
        rescue Errors::ContactCreatorArgumentError
          @messenger.puts OutputFormatter.usage
        end
      when 'list' then
        begin
          ContactLister.new(@messenger).list!(args[1..-1])
        rescue Errors::ContactListerArgumentError
          @messenger.puts OutputFormatter.usage
        end
      else
        raise Errors::ContactHandlerArgumentError
      end
    end
  end
end
