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
          case @args.first
          when 'create' then Creator.new(@args[1..-1]).run
          end
        else
          $stdout.puts Bell::USAGE
        end
      end

      def actions
        %w[create]
      end

      def valid_action?
        actions.include?(@args.first)
      end
    end

    class Creator
    end
  end
end
