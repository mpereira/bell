module Bell
  class UserCreator
    def initialize(messenger)
      @messenger = messenger
    end

    def create(user_attributes)
      if User.find(:name => user_attributes[:name])
        @messenger.puts OutputFormatter.user_already_exists(user_attributes[:name])
      else
        User.create(:name => user_attributes[:name])
        @messenger.puts OutputFormatter.user_created(user_attributes[:name])
      end
    end

    protected
    class << self
      def valid_args?(args)
        args.length == 1
      end

      def extract_attributes(args)
        { :name => args.first }
      end
    end
  end
end
