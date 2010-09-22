module Bell
  class ContactHandler
    def initialize(output)
      @output = output
    end

    def handle!(args)
      action, args = args.first, args[1..-1]

      case action
      when 'create' then
        if ContactCreator.valid_args?(args)
          contact_attributes = ContactCreator.extract_attributes(args)
          ContactCreator.new(@output).create(contact_attributes)
        else
          @output.puts USAGE
        end
      when 'list' then
        if ContactLister.valid_args?(args)
          user_attributes = {}
          user_attributes[:name] = args.first unless args.empty?
          ContactLister.new(@output).list(user_attributes)
        else
          @output.puts USAGE
        end
      else
        @output.puts USAGE
      end
    end
  end
end
