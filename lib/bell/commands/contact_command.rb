module Bell::Commands
  class ContactCommand < Command
    CONTACT_NUMBER_FLAGS = %w[-n --number]
    USER_NAME_FLAGS = %w[-u --user]

    def initialize(args = [])
      super(args)
      @handler = 'contacts_handler'
    end

    def parse
      case @args[0]
      when 'create' then
        @action = 'create'
        if valid_args_for_contact_creation?
          @params = contact_creation_params
        else
          raise ArgumentError
        end
      when 'import' then
        @action = 'import'
        if valid_args_for_contact_import?
          @params = contact_import_params
        else
          raise ArgumentError
        end
      when 'list' then
        @action = 'list'
        @params = { :user => { :name => @args[1] } } if @args[1]
      when 'remove' then
        if @args[1]
          @action = 'remove'
          @params = { :contact => { :name => @args[1] } }
        else
          raise ArgumentError
        end
      else
        raise ArgumentError
      end

      self
    end

    private

    def number_given?
      !(@args & CONTACT_NUMBER_FLAGS).empty?
    end

    def user_given?
      !(@args & USER_NAME_FLAGS).empty?
    end

    def valid_args_for_contact_creation?
      @args.length == 6 && number_given? && user_given?
    end

    def valid_args_for_contact_import?
      @args.length == 4 && user_given?
    end

    def contact_creation_params
      number_flag = (@args & CONTACT_NUMBER_FLAGS).first
      user_flag = (@args & USER_NAME_FLAGS).first

      contact_number = @args[@args.index(number_flag) + 1]
      user_name = @args[@args.index(user_flag) + 1]

      args = @args.dup
      args.delete(number_flag)
      args.delete(contact_number)
      args.delete(user_flag)
      args.delete(user_name)

      contact_name = args.last

      { :contact => { :name => contact_name, :number => contact_number },
        :user => { :name => user_name } }
    end

    def contact_import_params
      user_flag = (@args & USER_NAME_FLAGS).first

      user_name = @args[@args.index(user_flag) + 1]

      args = @args.dup
      args.delete(user_flag)
      args.delete(user_name)

      path = args.last

      { :path => path, :user => { :name => user_name } }
    end
  end
end
