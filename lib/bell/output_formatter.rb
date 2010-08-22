module Bell
  class OutputFormatter
    class << self
      def usage
        "bell te auxilia no controle de gastos de uma conta da " <<
        "embratel.\n\nComandos:\n" <<
        "  bell user create <USER>\n"
      end

      def user_exists(name)
        "O usuário #{name} já existe\n"
      end

      def user_created(name)
        "Usuário #{name} criado\n"
      end

      def no_users_in_database
        "Não há usuários cadastrados\n"
      end
    end
  end
end
