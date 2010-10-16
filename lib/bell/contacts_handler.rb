module Bell
  class ContactsHandler
    include Displayable

    def self.create(params = {})
      user = User.find(:name => params[:user][:name])
      if user
        contact = Contact.new(:name => params[:contact][:name],
                              :number => params[:contact][:number],
                              :user_id => user.id)
        if contact.valid?
          contact.save
          display Message.contact_created(contact)
        else
          display formatted_contact_errors(contact)
        end
      else
        display Message.user_does_not_exist(params[:user][:name])
      end
    end

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
            display formatted_contact_list(user.contacts, :user_contacts => true)
          end
        else
          display Message.user_does_not_exist(params[:user][:name])
        end
      end
    end

    def self.remove(params = {})
      if contact = Contact.find(:name => params[:contact][:name])
        contact.destroy
        display Message.contact_removed(params[:contact][:name])
      else
        display Message.contact_does_not_exist(params[:contact][:name])
      end
    end

    private
    def self.formatted_contact_errors(contact)
      contact.errors.first.last.first
    end

    def self.formatted_contact_list(contacts, options = {})
      contacts.inject("") do |list, contact|
        list << "#{contact.name} (#{contact.number})"
        list << " - #{contact.user.name}" unless options[:user_contacts]
        list << "\n"
      end
    end
  end
end
