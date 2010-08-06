module Bell
  USAGE = <<-USAGE
bell te auxilia no controle de gastos de uma conta da embratel.

Comandos:
  bell user create <USER>
  USAGE

  module User
    DATA_PATH = File.join(File.dirname(__FILE__), '..', 'data')

    def data_file(user)
      File.join(DATA_PATH, "#{user}.yml")
    end

    class Handler
      def initialize(args)
        @args = args
      end

      def actions
        %w[create]
      end

      def valid_action?
        actions.include?(@args.first)
      end

      def run
        if valid_action?
          case @args.first
          when 'create' then Creator.new(@args[1..-1]).run
          end
        else
          $stdout.puts Bell::USAGE
        end
      end
    end

    class Creator
      include User

      def initialize(args)
        @args = args
      end

      def user_exists?(user)
        File.exists?(data_file(user))
      end

      def run
        if @args.length == 1
          user = @args.first
          create(user) unless user_exists?(user)
        else
          $stdout.puts USAGE
        end
      end
    end
  end
end
