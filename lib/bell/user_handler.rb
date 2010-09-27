module Bell
  class UserHandler
    def initialize(output)
      @output = output
    end

    def handle(args)
      action, args = args.first, args[1..-1]

      case action
      when 'create' then
        if UserCreator.valid_args?(args)
          user_attributes = UserCreator.extract_attributes(args)
          UserCreator.new(@output).create(user_attributes)
        else
          @output.puts USAGE
        end
      when 'list' then
        if args.length.zero?
          UserLister.new(@output).list
        else
          @output.puts USAGE
        end
      when 'remove' then
        if UserRemover.valid_args?(args)
          user_attributes = UserRemover.extract_attributes(args)
          UserRemover.new(@output).remove(user_attributes)
        else
          @output.puts USAGE
        end
      else
        @output.puts USAGE
      end
    end
  end
end
