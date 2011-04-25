module Bell
  module CSVParser
    extend self
    include Displayable, Util::String

    def parse_contacts(options)
      contact_rows = CSV.read(options[:path])
    rescue Errno::ENOENT
      display(Message.no_such_file_or_directory(options[:path]))
    rescue Errno::EISDIR
      display(Message.path_is_a_directory(options[:path]))
    rescue CSV::MalformedCSVError
      display(Message.invalid_contacts_file(options[:path]))
    else
      user = User.find(:name => options[:user][:name]) if options[:user]
      valid_contacts = []
      contact_rows.each_with_index do |row, index|
        if row.size < 2
          display(Message.row_with_few_columns(row, index + 1))
        elsif row.size > 2
          display(Message.row_with_extra_columns(row, index + 1))
        else
          contact = if options[:user]
            UserContact.new(:name => sanitize(row.first),
                        :number => row.last,
                        :user_id => user.id)
          elsif options[:public]
            PublicContact.new(:name => sanitize(row.first), :number => row.last)
          end
          if contact
            if contact.valid?
              valid_contacts << contact
            else
              display(Message.
                        formatted_contact_errors(contact,
                                                 :line_number => index + 1))
            end
          end
        end
      end
      if contact_rows.size > 0
        if contact_rows.size == valid_contacts.size
          valid_contacts
        else
          raise InvalidContacts
        end
      else
        nil
      end
    end
  end
end
