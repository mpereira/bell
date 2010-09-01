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

      def no_users_in_database
        "Não há usuários cadastrados\n"
      end

      def user_created(user_name)
        "Usuário #{user_name} criado\n"
      end

      def user_exists(user_name)
        "O usuário #{user_name} já existe\n"
      end

      def user_does_not_exist(user_name)
        "O usuário #{user_name} não existe\n"
      end

      def contact_created(contact)
        "Contato #{contact.name}:#{contact.number} criado para #{contact.user.name}\n"
      end

      def contact_exists(contact_name)
        "O usuário #{contact_name} já existe\n"
      end

      def user_list
        User.all.map { |user| user.name }
      end
    end
  end
end
