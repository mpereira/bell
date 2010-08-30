module Bell
  class ContactHandler
    def initialize(messenger)
      @messenger = messenger
    end

    def run(args)
      action, args = args.first, args[1..-1]

      case action
      when 'create' then ContactCreator.new(@messenger).create(args)
      when 'list' then ContactLister.new(@messenger).list(args)
      else @messenger.puts OutputFormatter.usage
      end
    end
  end
end
