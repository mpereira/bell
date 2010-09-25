module Bell
  class ContactRemover
    def initialize(output)
      @output = output
    end

    def remove(contact_attributes)
      if contact = Contact.find(:name => contact_attributes[:name])
        contact.destroy
        @output.puts OutputFormatter.contact_removed(contact_attributes[:name])
      else
        @output.puts OutputFormatter.contact_does_not_exist(contact_attributes[:name])
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
