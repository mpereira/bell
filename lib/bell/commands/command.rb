module Bell::Commands
  class Command
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
      else raise ArgumentError
      end
    end
  end
end
