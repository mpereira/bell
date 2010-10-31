module Bell::Handlers
  class ContactsHandler
    include Bell::Displayable

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
            display formatted_contact_list(user.contacts,
                                           :user_contacts => true,
                                           :csv => params[:csv])
          end
        else
          display Bell::Message.user_does_not_exist(params[:user][:name])
        end
      end
    end

    def self.import(params = {})
      contacts = FasterCSV.read(params[:path])
    rescue Errno::ENOENT
      display Bell::Message.no_such_file_or_directory(params[:path])
    rescue Errno::EISDIR
      display Bell::Message.path_is_a_directory(params[:path])
    rescue FasterCSV::MalformedCSVError
      display Bell::Message.invalid_contacts_file(params[:path])
    else
      user = Bell::User.find(:name => params[:user][:name])
      if user
        contacts_to_be_created = []
        contacts.each_with_index do |row, index|
          if row.size < 2
            display Bell::Message.row_with_few_columns(row, index + 1)
          elsif row.size > 2
            display Bell::Message.row_with_extra_columns(row, index + 1)
          else
            contact = Bell::Contact.new(:name => row.first,
                                        :number => row.last,
                                        :user_id => user.id)
            if contact.valid?
              contacts_to_be_created << contact
            else
              display formatted_contact_errors(contact, :line_number => index + 1)
            end
          end
        end

        # only create contacts if all of them are valid
        if contacts.size == contacts_to_be_created.size
          contacts_to_be_created.each do |contact|
            contact.save
            display Bell::Message.contact_created(contact)
          end
        end
      else
        display Bell::Message.user_does_not_exist(params[:user][:name])
      end
    end

    private
    def self.formatted_contact_errors(contact, options = {})
      contact_error = contact.errors.first.last.first
      if options[:line_number]
        contact_error.split("\n").first.insert(4, " na linha #{options[:line_number]}")
      else
        contact_error
      end
    end

    def self.text_contact_list(contacts, options)
      contacts.inject("") do |list, contact|
        list << "#{contact.name} (#{contact.number})"
        list << " - #{contact.user.name}" unless options[:user_contacts]
        list << "\n"
      end
    end

    def self.csv_contact_list(contacts)
      contacts.inject("") do |list, contact|
        list << "\"#{contact.name}\",#{contact.number}\n"
      end
    end

    def self.formatted_contact_list(contacts, options = {})
      options[:csv] ? csv_contact_list(contacts) : text_contact_list(contacts, options)
    end
  end
end
