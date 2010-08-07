module Bell
  class UserHandler
    attr_reader :action, :args

    def initialize(args)
      @action = args.first
      @args = args[1..-1]
    end

    def available_actions
      %w[create]
    end

    def valid_action?
      available_actions.include?(action)
    end

    def run
      if valid_action?
        case action
        when 'create' then UserCreator.new(args).run
        end
      else
        $stdout.puts Bell::USAGE
      end
    end
  end
end
