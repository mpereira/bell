module Bell
  USAGE = <<-USAGE
bell te auxilia no controle de gastos de uma conta da embratel.

Comandos:
  bell user create <USER>
  USAGE

  class User
    class Handler
      def initialize(args)
        @args = args
      end

      def parse_args
        unless valid_action?
          $stdout.puts Bell::USAGE
        end
      end

      def actions
        %w[create]
      end

      def valid_action?
        actions.include?(@args[1])
      end
    end
  end
end
