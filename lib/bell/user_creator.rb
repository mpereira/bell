module Bell
  class UserCreator
    attr_reader :args, :messenger

    def initialize(args)
      @args = args
      @messenger = Messenger.new
    end

    def run
      if args.length == 1
        user_name = args.first
        user = User[:name => user_name]
        if user
          messenger.notify_user_existence(user_name)
        else
          User.create { |user| user.name = user_name }
          messenger.notify_user_creation(user.name)
        end
      else
        messenger.show_usage
      end
    end
  end
end
