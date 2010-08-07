module Bell
  class Messenger
    def show_usage
     $stdout << "bell te auxilia no controle de gastos de uma conta da " <<
                "embratel.\n\nComandos:\n" <<
                "  bell user create <USER>\n"
    end

    def notify_user_existence(name)
      $stdout.puts "./data/#{name}.yml já existe"
    end

    def notify_user_creation(name)
      $stdout.puts "./data/#{name}.yml criado"
    end
  end
end
