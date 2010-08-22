module Bell
  class UserCreator
    def initialize(messenger)
      @messenger = messenger
    end

    def run(args)
      if args.length == 1
        user_name = args.first
        user = User[:name => user_name]
        if user
          @messenger.puts OutputFormatter.user_exists(user_name)
        else
          User.create { |user| user.name = user_name }
          @messenger.puts OutputFormatter.user_created(user_name)
        end
      else
        @messenger.puts OutputFormatter.usage
      end
    end
  end
end
