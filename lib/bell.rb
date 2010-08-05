module Bell
  USAGE = <<-USAGE
bell te auxilia no controle de gastos de uma conta da embratel.

Comandos:
  bell user create <USER>
  USAGE

  module User
    class Handler
      def initialize(args)
        @args = args
      end

      def parse_args
        if valid_action?
          case @args[1]
          when 'create' then Creator.new(@args).run
          end
        else
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

    class Creator
    end
  end
end
