module Bell
  class UserHandler
    def initialize(messenger)
      @messenger = messenger
    end

    def available_actions
      %w[create]
    end

    def valid_action?
      available_actions.include?(action)
    end

    def run(args)
      case args.first
      when 'create' then UserCreator.new(@messenger).run(args[1..-1])
      else @messenger.puts Messenger.show_usage
      end
    end
  end
end
