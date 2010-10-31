module Bell::Commands
  class ContactCommand < Command
    USER_NAME_FLAGS = %w[-u --user]

    USAGE = <<-USAGE.gsub(/^      /, '')
      uso: bell contact [<ação>] [<argumentos>]

        Ações:
        list [--csv] [-u|--user <usuário>]
        import [-f|--force] /path/para/lista/de/contatos.csv -u|--user <usuário>
    USAGE

    LIST_USAGE = <<-LIST_USAGE.gsub(/^      /, '')
      uso: bell contact list [<argumentos>]

        Argumentos:
        --csv                 Lista de contatos em formato CSV
        -u|--user <usuário>   Lista somente os contatos de determinado usuário
    LIST_USAGE

    IMPORT_USAGE = <<-IMPORT_USAGE.gsub(/^      /, '')
      uso: bell contact import /path/contatos.csv -u|--user <usuário> [<argumentos>]

        Argumentos:
        -f|--force   Ignora a lista de contatos e faz uma importação forçada
    IMPORT_USAGE

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
          raise ArgumentError, IMPORT_USAGE
        end
      when 'list' then
        @action = 'list'
        if valid_args_for_contact_list?
          @params = contact_list_params
        else
          raise ArgumentError, LIST_USAGE
        end
      else
        raise ArgumentError, USAGE
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

    def valid_args_for_contact_list?
      args_without_csv = @args.reject { |element| element == '--csv' }
      user_given? ? args_without_csv.length == 3 : args_without_csv.length == 1
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

    def contact_list_params
      if user_given?
        user_flag = (@args & USER_NAME_FLAGS).first
        user_name = @args[@args.index(user_flag) + 1]

        { :user => { :name => user_name } }
      else
        {}
      end
    end
  end
end
