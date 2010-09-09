module Bell
  class ContactHandler
    def initialize(messenger)
      @messenger = messenger
    end

    def handle!(args)
      action, args = args.first, args[1..-1]

      case action
      when 'create' then
        raise Errors::ContactCreatorArgumentError unless ContactCreator.valid_args?(args)
        contact_attributes = ContactCreator.extract_attributes(args)
        ContactCreator.new(@messenger).create!(contact_attributes)
      when 'list' then
        begin
          ContactLister.new(@messenger).list!(args)
        rescue Errors::ContactListerArgumentError
          @messenger.puts USAGE
        end
      else
        raise Errors::ContactHandlerArgumentError
      end
    rescue Errors::ContactCreatorArgumentError
      @messenger.puts USAGE
    rescue Errors::ContactListerArgumentError
      @messenger.puts USAGE
    end
  end
end
