module Bell
  class CliHandler
    def initialize(output)
      @output = output
    end

    def handle!(args)
      case args.first
      when 'user' then UserHandler.new(@output).handle!(args[1..-1])
      when 'contact' then ContactHandler.new(@output).handle!(args[1..-1])
      when 'implode' then Bell.implode!
      else @output.puts USAGE
      end
    end
  end
end
