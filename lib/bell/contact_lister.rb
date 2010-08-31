module Bell
  class ContactLister
    def initialize(messenger)
      @messenger = messenger
    end

    def list(args)
      case args.length
      when 0 then list_all_contacts
      when 1 then
        user_name = args.first
        user = User[:name => user_name]

        if user
          list_user_contacts(user)
        else
          @messenger.puts OutputFormatter.user_does_not_exist(user_name)
        end
      else
        @messenger.puts OutputFormatter.usage
      end
    end

    private
    def list_user_contacts(user)
      contacts = user.contacts

      if contacts.empty?
        @messenger.puts OutputFormatter.user_does_not_have_contacts(user[:name])
      else
        @messenger.puts "#{user[:name]}"

        contacts.each do |contact|
          @messenger.puts "  #{contact.number} - #{contact.name}"
        end
      end
    end
  end
end
