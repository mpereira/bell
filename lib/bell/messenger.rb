module Bell
  class Messenger
    def notify_user_existence(name)
      $stdout.puts "./data/#{name}.yml já existe"
    end

    def notify_user_creation(name)
      $stdout.puts "./data/#{name}.yml criado"
    end
  end
end
