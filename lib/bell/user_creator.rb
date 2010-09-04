module Bell
  class UserCreator
    def initialize(messenger)
      @messenger = messenger
    end

    def run(args)
      raise Errors::UserCreatorArgumentError unless args.length == 1

      user_name = args.first
      user = User.find(:name => user_name)

      if user
        @messenger.puts OutputFormatter.user_already_exists(user_name)
      else
        User.create(:name => user_name)
        @messenger.puts OutputFormatter.user_created(user_name)
      end
    end
  end
end
