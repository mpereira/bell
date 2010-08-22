module Bell
  class UserLister
    def initialize(messenger)
      @messenger = messenger
    end

    def run(args)
      if args.length == 0
        if User.empty?
          @messenger.puts OutputFormatter.no_users_in_database
        else
          @messenger.puts User.all.map { |user| user[:name] }
        end
      else
        @messenger.puts OutputFormatter.usage
      end
    end
  end
end
