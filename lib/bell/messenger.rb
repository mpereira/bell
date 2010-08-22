module Bell
  class Message
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

      def no_users_in_database
        "Não há usuários cadastrados\n"
      end
    end
  end
end
