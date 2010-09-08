module Bell
  class UserHandler
    def initialize(messenger)
      @messenger = messenger
    end

    def handle!(args)
      action, args = args.first, args[1..-1]

      case action
      when 'create' then
        raise Errors::UserCreatorArgumentError unless UserCreator.valid_args?(args)
        user_attributes = UserCreator.extract_attributes(args)
        UserCreator.new(@messenger).create(user_attributes)
      when 'list' then
        raise Errors::UserListerArgumentError unless args.length.zero?
        UserLister.new(@messenger).list
      else
        raise Errors::UserHandlerArgumentError
      end
    rescue Errors::UserCreatorArgumentError
      @messenger.puts USAGE
    rescue Errors::UserListerArgumentError
      @messenger.puts USAGE
    end
  end
end
