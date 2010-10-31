module Bell::Commands
  class Command
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
  end
end
