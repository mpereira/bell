module Bell
  class ContactCreator
    NUMBER_FLAGS = %w[-n --number]
    USER_FLAGS = %w[-u --user]

    def initialize(messenger)
      @messenger = messenger
    end

    def create!(args)
      raise Errors::ContactCreatorArgumentError unless valid_contact_creation_args?(args)

      contact_attributes = extract_contact_creation_args(args)
      user = User.find(:name => contact_attributes[:user])

      raise Errors::UserDoesNotExist unless user

      contact = Contact.find(:name => contact_attributes[:name], :user_id => user.id)

      if contact
        raise Errors::ContactAlreadyExists
      else
        contact = user.add_contact(
          :name => contact_attributes[:name],
          :number => contact_attributes[:number]
        )
        @messenger.puts OutputFormatter.contact_created(contact)
      end
    rescue Errors::UserDoesNotExist
      @messenger.puts OutputFormatter.user_does_not_exist(contact_attributes[:user])
    rescue Errors::ContactAlreadyExists
      @messenger.puts OutputFormatter.contact_already_exists(contact)
    end

    private
    def number_given?(args)
      !(args & NUMBER_FLAGS).empty?
    end

    def user_given?(args)
      !(args & USER_FLAGS).empty?
    end

    def necessary_arguments_given?(args)
      number_given?(args) && user_given?(args)
    end

    def valid_contact_creation_args?(args)
      args.length == 5 && necessary_arguments_given?(args)
    end

    def extract_contact_creation_args(args)
      number_flag = (args & NUMBER_FLAGS).first
      user_flag = (args & USER_FLAGS).first

      number = args[args.index(number_flag) + 1]
      user = args[args.index(user_flag) + 1]

      args.delete(number_flag)
      args.delete(number)
      args.delete(user_flag)
      args.delete(user)

      name = args.first

      contact_attributes = {}
      contact_attributes.merge!(:name => name)
      contact_attributes.merge!(:number => number)
      contact_attributes.merge!(:user => user)
    end
  end
end
