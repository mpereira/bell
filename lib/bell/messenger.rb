module Bell
  class Messenger
    def show_usage
     $stdout << "bell te auxilia no controle de gastos de uma conta da " <<
                "embratel.\n\nComandos:\n" <<
                "  bell user create <USER>\n"
    end

    def notify_user_existence(name)
      $stdout.puts "O usuário #{name} já existe"
    end

    def notify_user_creation(name)
      $stdout.puts "Usuário #{name} criado"
    end
  end
end
