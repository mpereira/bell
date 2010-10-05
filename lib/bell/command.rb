module Bell
  class Command
    def initialize(args = [])
      @args = args
      @handler ||= nil
      @action ||= nil
      @params = {}
    end

    def hash
      {
        :handler => @handler,
        :action => @action,
        :params => @params
      }
    end

    def build
      case @args[0]
      when 'user' then UserCommand.new(@args[1..-1]).build
      when 'contact' then ContactCommand.new(@args[1..-1]).build
      when 'report' then ReportCommand.new(@args[1..-1]).build
      when 'implode' then ImplosionCommand.new(@args[1..-1]).build
      else raise ArgumentError
      end
    end
  end

  class UserCommand < Command
    def initialize(args = [])
      super(args)
      @handler = 'users_handler'
    end

    def build
      case @args[0]
      when 'create' then
        if @args[1]
          @action = 'create'
          @params = { :user => { :name => @args[1] } }
        else
          raise ArgumentError
        end
      when 'list' then
        @action = 'list'
      when 'remove' then
        if @args[1]
          @action = 'remove'
          @params = { :user => { :name => @args[1] } }
        else
          raise ArgumentError
        end
      end

      self
    end
  end

  class ContactCommand < Command
    CONTACT_NUMBER_FLAGS = %w[-n --number]
    USER_NAME_FLAGS = %w[-u --user]

    def initialize(args = [])
      super(args)
      @handler = 'contacts_handler'
    end

    def build
      case @args[0]
      when 'create' then
        if @args[1]
          @action = 'create'
          @params = contact_creation_params if valid_args_for_contact_creation?
        else
          raise ArgumentError
        end
      when 'list' then
        @action = 'list'
      when 'remove' then
        if @args[1]
          @action = 'remove'
          @params = { :user => { :name => @args[1] } }
        else
          raise ArgumentError
        end
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

    def necessary_arguments_given?
      number_given? && user_given?
    end

    def valid_args_for_contact_creation?
      @args.length == 6 && necessary_arguments_given?
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

      {
        :contact => { :name => contact_name, :number => contact_number },
        :user => { :name => user_name }
      }
    end
  end

  class ReportCommand < Command
    def initialize(args = [])
      super(args)
      @handler = 'reports_handler'
    end

    def build
      case @args[0]
      when 'create' then
        @action = 'create'
        if @args[1]
          @params = { :path => @args[1] }
        else
          raise ArgumentError
        end
      end

      self
    end
  end

  class ImplosionCommand < Command
    def initialize(args = [])
      super(args)
      @handler = 'implosions_handler'
    end

    def build
      case @args[0]
      when 'implode' then
        @action = 'implode'
      end

      self
    end
  end
end
