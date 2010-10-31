module Bell::Commands
  class Command
    USER_NAME_FLAGS = %w[-u --user]
    CONTACT_NUMBER_FLAGS = %w[-n --number]

    USAGE = <<-USAGE.gsub(/^      /, '')
      uso: bell [--version] [--help] <comando> [<ação>] [<argumentos>]

        Comandos:
        user      Cria, lista, renomeia ou remove usuários
        contact   Importa uma lista de contatos ou liste contatos
        report    Mostra relatórios completos, de usuário ou de ligação
        implode   Remove todos os usuários e contatos

      Veja `bell help <comando>` para mais informações sobre um comando específico
    USAGE

    def initialize(args = [])
      @args = args
      @handler ||= nil
      @action ||= nil
      @params = {}
    end

    def route
      { :handler => @handler,
        :action => @action,
        :params => @params }
    end

    def parse
      case @args[0]
      when 'user' then UserCommand.new(@args[1..-1]).parse
      when 'contact' then ContactCommand.new(@args[1..-1]).parse
      when 'report' then ReportCommand.new(@args[1..-1]).parse
      when 'implode' then ImplosionCommand.new(@args[1..-1]).parse
      else raise ArgumentError, USAGE
      end
    end

    protected

    def user_name_given?
      !(@args & USER_NAME_FLAGS).empty?
    end

    def contact_number_given?
      !(@args & USER_NAME_FLAGS).empty?
    end
  end
end
