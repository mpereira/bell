module Bell
  class UserHandler
    attr_reader :action, :args, :messenger

    def initialize(args)
      @action = args.first
      @args = args[1..-1]
      @messenger = Messenger.new
    end

    def available_actions
      %w[create]
    end

    def valid_action?
      available_actions.include?(action)
    end

    def run
      case action
      when 'create' then UserCreator.new(args).run
      else messenger.show_usage
      end
    end
  end
end
