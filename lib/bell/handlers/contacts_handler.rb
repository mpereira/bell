module Bell::Handlers
  class ContactsHandler
    include Bell::Displayable

    def self.create(params = {})
      user = Bell::User.find(:name => params[:user][:name])
      if user
        contact = Bell::Contact.new(:name => params[:contact][:name],
                                    :number => params[:contact][:number],
                                    :user_id => user.id)
        if contact.valid?
          contact.save
          display Bell::Message.contact_created(contact)
        else
          display formatted_contact_errors(contact)
        end
      else
        display Bell::Message.user_does_not_exist(params[:user][:name])
      end
    end

    def self.list(params = {})
      if params.empty?
        if Bell::Contact.empty?
          display Bell::Message.no_contacts_created
        else
          display formatted_contact_list(Bell::Contact.all)
        end
      else
        if user = Bell::User.find(:name => params[:user][:name])
          if user.contacts.empty?
            display Bell::Message.contact_list_empty(user.name)
          else
            display formatted_contact_list(user.contacts, :user_contacts => true)
          end
        else
          display Bell::Message.user_does_not_exist(params[:user][:name])
        end
      end
    end

    def self.remove(params = {})
      if contact = Bell::Contact.find(:name => params[:contact][:name])
        contact.destroy
        display Bell::Message.contact_removed(params[:contact][:name])
      else
        display Bell::Message.contact_does_not_exist(params[:contact][:name])
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
