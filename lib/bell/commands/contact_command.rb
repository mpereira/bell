# encoding: utf-8

module Bell::Commands
  class ContactCommand < Command
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

    def initialize(args)
      super(args)
      @handler = 'contacts_handler'
      @action = @args.shift
    end

    def parse
      case @action
      when 'import' then
        if valid_contact_import_args?(@args)
          @params = extract_contact_import_params(@args)
        else
          raise ArgumentError, IMPORT_USAGE
        end
      when 'list' then
        if valid_contact_list_args?(@args)
          @params = extract_contact_list_params(@args)
        else
          raise ArgumentError, LIST_USAGE
        end
      else
        raise ArgumentError, USAGE
      end

      self
    end

    private

    def valid_contact_import_args?(args)
      (args.length == 3 && user_name_given?) ||
        (args.length == 2 && args.any? { |e| e == '-p' || e == '--public' })
    end

    def valid_contact_list_args?(args)
      args_without_csv = args.reject { |element| element == '--csv' }
      user_name_given? ? args_without_csv.length == 2 : args_without_csv.length == 0
    end

    def extract_contact_import_params(args)
      if user_name_given?
        user_name_flag = (args & USER_NAME_FLAGS).first
        user_name = args[args.index(user_name_flag) + 1]
        args.reject! { |e| e == user_name_flag || e == user_name }
        path = args[0]
        { :path => path, :user => { :name => user_name } }
      elsif args.any? { |e| e == '-p' || e == '--public' }
        { :path => args.first, :public => true }
      end
    end

    def extract_contact_list_params(args)
      if user_name_given?
        user_name_flag = (args & USER_NAME_FLAGS).first
        user_name = args[args.index(user_name_flag) + 1]
        csv_flag = !((args & CSV_FLAGS).first || []).empty?
        params = { :user => { :name => user_name } }
        csv_flag ? params.merge(:csv => csv_flag) : params
      else
        {}
      end
    end
  end
end
