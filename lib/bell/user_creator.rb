module Bell
  class UserCreator
    def initialize(messenger)
      @messenger = messenger
    end

    def run(args)
      raise ArgumentError unless args.length == 1
      user_name = args.first
      User.create(:name => user_name)
    rescue ArgumentError
      @messenger.puts OutputFormatter.usage
    rescue Sequel::DatabaseError
      @messenger.puts OutputFormatter.user_exists(user_name)
    else
      @messenger.puts OutputFormatter.user_created(user_name)
    end
  end
end
