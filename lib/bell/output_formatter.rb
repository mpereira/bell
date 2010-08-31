module Bell
  class OutputFormatter
    class << self
      def usage
        "bell te auxilia no controle de gastos de uma conta da embratel." <<
        "\n\nComandos:\n" <<
        "  bell user create USER\n" <<
        "  bell user list\n" <<
        "  bell contact create CONTACT [-n|--number] NUMBER [-u|--user] USER\n" <<
        "  bell contact list\n"
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

      def contact_created(contact)
        "Contato #{contact.name}:#{contact.number} criado para #{contact.user.name}\n"
      end

      def user_does_not_exist(user)
        "O usuário #{user} não existe\n"
      end
    end
  end
end
