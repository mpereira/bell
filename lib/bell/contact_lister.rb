module Bell
  class ContactLister
    def initialize(messenger)
      @messenger = messenger
    end

    def list!(args)
      case args.length
      when 0 then
        if Contact.all.empty?
          @messenger.puts OutputFormatter.no_contacts_in_database
        else
          list_contacts(Contact.all)
        end
      when 1 then
        user_name = args.first
        user = User.find(:name => user_name)

        if user
          list_user_contacts(user)
        else
          raise Errors::UserDoesNotExist
        end
      else
        raise Errors::ContactListerArgumentError
      end
    rescue Errors::UserDoesNotExist
      @messenger.puts OutputFormatter.user_does_not_exist(user_name)
    end

    private
    def list_contacts(contacts)
      unless contacts.empty?
        contacts.each do |contact|
          @messenger.puts "#{contact.number} - #{contact.name}"
        end
      end
    end

    def list_user_contacts(user)
      user_contacts = user.contacts

      if user_contacts.empty?
        @messenger.puts OutputFormatter.user_does_not_have_contacts(user[:name])
      else
        list_contacts(user_contacts)
      end
    end
  end
end
