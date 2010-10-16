module Bell
  module Message
    extend self

    def no_created_users
      "Nenhum usuário criado."
    end

    def user_created(user_name)
      "Usuário '#{user_name}' criado."
    end

    def user_already_exists(user_name)
      "erro: o usuário '#{user_name}' já existe."
    end

    def user_does_not_exist(user_name)
      "erro: o usuário '#{user_name}' não existe."
    end

    def user_removed(user_name)
      "Usuário '#{user_name}' removido."
    end

    def no_contacts_created
      "Nenhum contato criado."
    end

    def contact_list_empty(user_name)
      "A lista de contatos do usuário '#{user_name}' está vazia."
    end

    def contact_created(contact)
      "'#{contact.name} (#{contact.number})' adicionado à lista de contatos do usuário '#{contact.user.name}'."
    end

    def contact_removed(contact_name)
      "Contato '#{contact_name}' removido."
    end

    def contact_does_not_exist(contact_name)
      "erro: não existe contato com nome '#{contact_name}'."
    end

    def contact_name_taken(contact_name)
      contact = Contact.find(:name => contact_name)
      "erro: este nome já é usado pelo contato '#{contact.name} (#{contact.number})' do usuário '#{contact.user.name}'.\nCrie um contato com nome diferente." if contact
    end

    def contact_number_taken(contact_number)
      contact = Contact.find(:number => contact_number)
      "erro: este número já é usado pelo contato '#{contact.name} (#{contact.number})' do usuário '#{contact.user.name}'.\nCrie um contato com número diferente." if contact
    end

    def bad_format_for_contact_number(contact_number)
      "erro: '#{contact_number}' não é um número de telefone válido.\nVeja 'bell --help' para saber mais sobre o formato aceito."
    end

    def no_such_file_or_directory(path)
      "erro: o arquivo/diretório '#{path}' não existe."
    end

    def path_is_a_directory(path)
      "erro: '#{path}' é um diretório."
    end

    def invalid_phone_bill_file(path)
      "erro: '#{path}' não é uma fatura válida da embratel."
    end
  end
end
