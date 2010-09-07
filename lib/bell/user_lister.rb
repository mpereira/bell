module Bell
  class UserLister
    def initialize(messenger)
      @messenger = messenger
    end

    def list!(args = [])
      raise Errors::UserListerArgumentError unless args.length.zero?

      if User.empty?
        @messenger.puts OutputFormatter.no_created_users
      else
        list_users
      end
    end

    private
    def list_users
      @messenger.puts User.all.map(&:name)
    end
  end
end
