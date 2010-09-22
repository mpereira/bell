module Bell
  class ContactHandler
    def initialize(messenger)
      @messenger = messenger
    end

    def handle!(args)
      action, args = args.first, args[1..-1]

      case action
      when 'create' then
        if ContactCreator.valid_args?(args)
          contact_attributes = ContactCreator.extract_attributes(args)
          ContactCreator.new(@messenger).create(contact_attributes)
        else
          @messenger.puts USAGE
        end
      when 'list' then
        if ContactLister.valid_args?(args)
          user_attributes = {}
          user_attributes[:name] = args.first unless args.empty?
          ContactLister.new(@messenger).list(user_attributes)
        else
          @messenger.puts USAGE
        end
      else
        @messenger.puts USAGE
      end
    end
  end
end
