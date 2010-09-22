module Bell
  class ContactLister
    def initialize(output)
      @output = output
    end

    def list(user_attributes = {})
      if user_attributes.empty?
        if Contact.empty?
          @output.puts OutputFormatter.no_contacts_created
        else
          list_contacts(Contact.all)
        end
      else
        user_name = user_attributes[:name]
        user = User.find(:name => user_name)
        if user
          list_user_contacts(user)
        else
          @output.puts OutputFormatter.user_does_not_exist(user_name)
        end
      end
    end

    class << self
      def valid_args?(args)
        [0, 1].include?(args.length)
      end
    end

    private
    def list_contacts(contacts)
      unless contacts.empty?
        contacts.each do |contact|
          @output.puts "#{contact.number} - #{contact.name}"
        end
      end
    end

    def list_user_contacts(user)
      if user.contacts.empty?
        @output.puts OutputFormatter.contact_list_empty(user.name)
      else
        list_contacts(user.contacts)
      end
    end
  end
end
