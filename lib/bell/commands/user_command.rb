module Bell::Commands
  class UserCommand < Command
    USAGE = <<-USAGE.gsub(/^      /, '')
      uso: bell user [<ação>]

        Ações:
        create <usuário>
        rename <nome anterior> <novo nome>
        list
        remove <usuário>
    USAGE

    CREATE_USAGE = <<-CREATE_USAGE.gsub(/^      /, '')
      uso: bell user create <usuário>
    CREATE_USAGE

    RENAME_USAGE = <<-RENAME_USAGE.gsub(/^      /, '')
      uso: bell user rename <nome anterior> <novo nome>
    RENAME_USAGE

    REMOVE_USAGE = <<-REMOVE_USAGE.gsub(/^      /, '')
      uso: bell user create <usuário>
    REMOVE_USAGE

    def initialize(args = [])
      super(args)
      @handler = 'users_handler'
    end

    def parse
      case @args[0]
      when 'create' then
        if @args[1]
          @action = 'create'
          @params = { :user => { :name => @args[1] } }
        else
          raise ArgumentError, CREATE_USAGE
        end
      when 'list' then
        @action = 'list'
      when 'remove' then
        if @args[1]
          @action = 'remove'
          @params = { :user => { :name => @args[1] } }
        else
          raise ArgumentError, CREATE_USAGE
        end
      else
        raise ArgumentError, USAGE
      end

      self
    end
  end
end
