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

      def user_already_exists(user_name)
        "O usuário #{user_name} já existe\n"
      end

      def user_does_not_exist(user_name)
        "O usuário #{user_name} não existe\n"
      end

      def no_contacts_in_database
        "Não há contatos cadastrados\n"
      end

      def contact_created(contact)
        "Contato #{contact.name}:#{contact.number} criado para #{contact.user.name}\n"
      end

      def contact_already_exists(contact)
        "O contato #{contact.name} já existe na lista de contatos do usuário #{contact.user.name}\n"
      end

      def contact_number_already_taken(contact)
        "O número #{contact.number} já pertence ao contato #{contact.name} do usuário#{contact.user.name}\n"
      end

      def bad_format_for_contact_number(contact_number)
        sanitize_output(
          %Q{erro: #{contact_number} não é um número de telefone válido.
             Veja 'bell --help' para saber mais sobre o formato aceito.}
        )
      end

      def user_list
        User.all.map { |user| user.name }
      end

      private
      def sanitize_output(output)
        output.gsub(/^\s{2,}/, '')
      end
    end
  end
end
