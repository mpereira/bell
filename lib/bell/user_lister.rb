module Bell
  class UserLister
    def initialize(messenger)
      @messenger = messenger
    end

    def run(args)
      if args.length == 0
        if User.empty?
          @messenger.puts Message.no_users_in_database
        else
          @messenger.puts User.all.join('\n')
        end
      else
        @messenger.puts Message.show_usage
      end
    end
  end
end
