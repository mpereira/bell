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
          @messenger.puts Messenger.notify_user_existence(user_name)
        else
          User.create { |user| user.name = user_name }
          @messenger.puts Messenger.notify_user_creation(user_name)
        end
      else
        @messenger.puts Messenger.show_usage
      end
    end
  end
end
