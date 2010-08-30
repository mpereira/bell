module Bell
  class ContactCreator
    PHONE_FLAGS = %w[-p --phone]
    USER_FLAGS = %w[-u --user]

    def initialize(messenger)
      @messenger = messenger
    end

    def create(args)
      raise ArgumentError unless valid_contact_creation_args?(args)

      contact_attributes = extract_contact_creation_args(args)

      begin
        user = User[:name => contact_attributes[:user]]
        contact = Contact.create(
          :name => contact_attributes[:name],
          :phone => contact_attributes[:phone]
        )

        user.add_contact(contact)
      rescue NoMethodError
        @messenger.puts OutputFormatter.user_does_not_exist(contact_attributes[:user])
      end
    end

    private
    def phone_given?(args)
      !(args & PHONE_FLAGS).empty?
    end

    def user_given?(args)
      !(args & USER_FLAGS).empty?
    end

    def necessary_arguments_given?(args)
      phone_given?(args) && user_given?(args)
    end

    def valid_contact_creation_args?(args)
      args.length == 5 && necessary_arguments_given?(args)
    end

    def extract_contact_creation_args(args)
      phone_flag = (args & PHONE_FLAGS).first
      user_flag = (args & USER_FLAGS).first

      phone = args[args.index(phone_flag) + 1]
      user = args[args.index(user_flag) + 1]

      args.delete(phone_flag)
      args.delete(phone)
      args.delete(user_flag)
      args.delete(user)

      name = args.first

      contact_attributes = {}
      contact_attributes.merge!(:name => name)
      contact_attributes.merge!(:phone => phone)
      contact_attributes.merge!(:user => user)
    end
  end
end
