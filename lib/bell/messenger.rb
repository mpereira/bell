module Bell
  class Messenger
    class << self
      def show_usage
        "bell te auxilia no controle de gastos de uma conta da " <<
        "embratel.\n\nComandos:\n" <<
        "  bell user create <USER>\n"
      end

      def notify_user_existence(name)
        "O usuário #{name} já existe\n"
      end

      def notify_user_creation(name)
        "Usuário #{name} criado\n"
      end
    end
  end
end
