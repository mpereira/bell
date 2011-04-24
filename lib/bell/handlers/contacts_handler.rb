module Bell
  module Handlers
    class ContactsHandler
      include Displayable

      def self.list(params = {})
        if params.empty?
          if Contact.empty?
            display Message.no_contacts_created
          else
            display formatted_contact_list(Contact.all)
          end
        else
          if user = User.find(:name => params[:user][:name])
            if user.contacts.empty?
              display Message.contact_list_empty(user.name)
            else
              display formatted_contact_list(user.contacts,
                                             :user_contacts => true,
                                             :csv => params[:csv])
            end
          else
            display Message.user_does_not_exist(params[:user][:name])
          end
        end
      end

      def self.import(params)
        if params[:user]
          user = User.find(:name => params[:user][:name])
          if user
            if contacts = CSVParser.parse_contacts(params)
              contacts.each do |contact|
                contact.save && display(Bell::Message.contact_created(contact))
              end
            end
          else
            display(Message.user_does_not_exist(params[:user][:name]))
          end
        elsif params[:public]
          if contacts = CSVParser.parse_contacts(params)
            contacts.each do |contact|
              contact.save &&
                display(Bell::Message.contact_created(contact, :public => true))
            end
          end
        end
      rescue InvalidContacts
        display(Message.no_contacts_created)
      end

      private

      def self.text_contact_list(contacts, options)
        contacts.inject('') do |list, contact|
          list << "#{contact.name} (#{contact.number})"
          list << " - #{contact.user.name}" unless options[:user_contacts]
          list << "\n"
        end
      end

      def self.csv_contact_list(contacts)
        contacts.inject('') do |list, contact|
          list << "\"#{contact.name}\",#{contact.number}\n"
        end
      end

      def self.formatted_contact_list(contacts, options = {})
        options[:csv] ? csv_contact_list(contacts) : text_contact_list(contacts, options)
      end
    end
  end
end
