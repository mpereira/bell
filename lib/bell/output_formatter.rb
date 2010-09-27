module Bell
  class OutputFormatter
    class << self
      def no_created_users
        %Q{Nenhum usuário criado.}
      end

      def user_created(user_name)
        sanitize_output(%Q{Usuário '#{user_name}' criado.})
      end

      def user_already_exists(user_name)
        sanitize_output(%Q{erro: o usuário '#{user_name}' já existe.})
      end

      def user_does_not_exist(user_name)
        sanitize_output(%Q{erro: o usuário '#{user_name}' não existe.})
      end

      def user_removed(user_name)
        sanitize_output(%Q{Usuário '#{user_name}' removido.})
      end

      def no_contacts_created
        %Q{Nenhum contato criado.}
      end

      def contact_list_empty(user_name)
        %Q{A lista de contatos do usuário '#{user_name}' está vazia.}
      end

      def contact_created(contact)
        sanitize_output(
          %Q{'#{contact.name} (#{contact.number})' adicionado à lista de contatos do usuário  '#{contact.user.name}'.}
        )
      end

      def contact_removed(contact_name)
        sanitize_output(%Q{Contaco '#{contact_name}' removido.})
      end

      def contact_does_not_exist(contact_name)
        sanitize_output(%Q{erro: não existe contato com nome '#{contact_name}'.})
      end

      def contact_name_taken(contact_name)
        contact = Contact.find(:name => contact_name)
        sanitize_output(
          %Q{erro: este nome já é usado pelo contato '#{contact.name} (#{contact.number})' do usuário '#{contact.user.name}'.
             Crie um contato com nome diferente.}
        ) if contact
      end

      def contact_number_taken(contact_number)
        contact = Contact.find(:number => contact_number)
        sanitize_output(
          %Q{erro: este número já é usado pelo contato '#{contact.name} (#{contact.number})' do usuário '#{contact.user.name}'.
             Crie um contato com número diferente.}
        ) if contact
      end

      def bad_format_for_contact_number(contact_number)
        sanitize_output(
          %Q{erro: '#{contact_number}' não é um número de telefone válido.
             Veja 'bell --help' para saber mais sobre o formato aceito.}
        )
      end

      def no_such_file_or_directory(path)
        sanitize_output(
          %Q{erro: o arquivo/diretório '#{path}' não existe.}
        )
      end

      def path_is_a_directory(path)
        sanitize_output(
          %Q{erro: '#{path}' é um diretório.}
        )
      end

      def invalid_phone_bill_file(path)
        sanitize_output(
          %Q{erro: '#{path}' não é uma fatura válida da embratel.}
        )
      end

      private
      def sanitize_output(output)
        output.gsub(/^\s{2,}/, '')
      end
    end
  end
end
