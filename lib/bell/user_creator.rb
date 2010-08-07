module Bell
  class UserCreator
    attr_reader :args, :messenger

    def initialize(args)
      @args = args
      @messenger = Messenger.new
    end

    def run
      if args.length == 1
        user = User.new(args)
        if user.exists?
          messenger.notify_user_existence(user.name)
        else
          user.create
          messenger.notify_user_creation(user.name)
        end
      else
        messenger.show_usage
      end
    end
  end
end
