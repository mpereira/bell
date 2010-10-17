module Bell::Commands
  class Command
    def initialize(args = [])
      @args = args
      @handler ||= nil
      @action ||= nil
      @params = {}
    end

    def hash
      { :handler => @handler,
        :action => @action,
        :params => @params }
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
end
