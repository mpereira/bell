module Bell
  USAGE = <<-USAGE
bell te auxilia no controle de gastos de uma conta da embratel.

Comandos:
  bell user create <USER>
  USAGE

  class UserHandler
    VALID_SECOND_ARGS = %w[create]

    def initialize(args)
      @args = args
    end

    def parse_args
      unless valid_args?
        $stdout.puts Bell::USAGE
      end
    end

    def valid_args?
      (@args.length == 1) || (VALID_SECOND_ARGS.include? @args[1])
    end
  end
end
