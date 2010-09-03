module Bell
  class UserLister
    def initialize(messenger)
      @messenger = messenger
    end

    def run(args)
      raise Errors::UserListerArgumentError unless args.length.zero?

      if User.empty?
        @messenger.puts OutputFormatter.no_users_in_database
      else
        @messenger.puts OutputFormatter.user_list
      end
    end
  end
end
