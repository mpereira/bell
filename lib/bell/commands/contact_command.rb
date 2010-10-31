module Bell::Commands
  class ContactCommand < Command
    USER_NAME_FLAGS = %w[-u --user]

    def initialize(args = [])
      super(args)
      @handler = 'contacts_handler'
    end

    def parse
      case @args[0]
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
      else
        raise ArgumentError
      end

      self
    end

    private

    def user_given?
      !(@args & USER_NAME_FLAGS).empty?
    end

    def valid_args_for_contact_import?
      @args.length == 4 && user_given?
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
