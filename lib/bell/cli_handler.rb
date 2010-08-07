$:.unshift File.join(File.dirname(__FILE__))
require 'messenger'

module Bell
  class CliHandler
    attr_reader :messenger

    def initialize(args)
      @args = args
      @messenger = Messenger.new
    end

    def run
      case @args.first
      when 'user' then UserHandler.new(@args[1..-1]).run
      else messenger.show_usage
      end
    end
  end
end
