module Bell
  class UserHandler
    def initialize(messenger)
      @messenger = messenger
    end

    def handle!(args)
      action, args = args.first, args[1..-1]

      case action
      when 'create' then
        if UserCreator.valid_args?(args)
          user_attributes = UserCreator.extract_attributes(args)
          UserCreator.new(@messenger).create(user_attributes)
        else
          @messenger.puts USAGE
        end
      when 'list' then
        if args.length.zero?
          UserLister.new(@messenger).list
        else
          @messenger.puts USAGE
        end
      else
        @messenger.puts USAGE
      end
    end
  end
end
