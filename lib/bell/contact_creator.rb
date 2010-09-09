module Bell
  class ContactCreator
    NUMBER_FLAGS = %w[-n --number]
    USER_FLAGS = %w[-u --user]

    def initialize(messenger)
      @messenger = messenger
    end

    def create!(contact_attributes)
      user_name = contact_attributes[:user][:name]
      user = User.find(:name => user_name)
      contact = Contact.new(contact_attributes[:contact])
      user.add_contact(contact)
    rescue NoMethodError
      @messenger.puts OutputFormatter.user_does_not_exist(user_name)
    rescue Sequel::ValidationFailed
      contact.errors.each_value { |value| @messenger.puts value }
    else
      @messenger.puts OutputFormatter.contact_created(contact)
    end

    private
    class << self
      def number_given?(args)
        !(args & NUMBER_FLAGS).empty?
      end

      def user_given?(args)
        !(args & USER_FLAGS).empty?
      end

      def necessary_arguments_given?(args)
        number_given?(args) && user_given?(args)
      end

      def valid_args?(args)
        args.length == 5 && necessary_arguments_given?(args)
      end

      def extract_attributes(args)
        number_flag = (args & NUMBER_FLAGS).first
        user_flag = (args & USER_FLAGS).first

        number = args[args.index(number_flag) + 1]
        user = args[args.index(user_flag) + 1]

        args.delete(number_flag)
        args.delete(number)
        args.delete(user_flag)
        args.delete(user)

        name = args.first

        {
          :contact => { :name => name, :number => number },
          :user => { :name => user }
        }
      end
    end
  end
end
