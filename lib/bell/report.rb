module Bell
  class Report
    def initialize(phone_bill)
      @phone_bill = phone_bill
    end

    def to_s
      %{
      [resumo]
      #{formatted_total}
      #{formatted_known_total}
      #{formatted_unknown_total}

      [usuários]
      #{users.map { |user| %{#{formatted_user(user)}} }.join("\n")}

      [ligações desconhecidas]
      #{unknown_calls.map { |call| %{#{formatted_call(call)}} }.join("\n")}
      }.gsub(/^\ {6,}/, '')
    end

    private
    def formatted_total
      %{#{"Total:"}}.ljust(25) << sprintf("%.2f", total)
    end

    def formatted_known_total
      %{#{"De usuários:"}}.ljust(26) << sprintf("%.2f", known_total)
    end

    def formatted_unknown_total
      %{#{"Desconhecidas:"}}.ljust(25) << sprintf("%.2f", unknown_total)
    end

    def formatted_user(user)
      %{#{user[:name]}}.ljust(25) << sprintf("%.2f", user[:total])
    end

    def formatted_call(call)
      %{#{call.number_called}}.ljust(25) << sprintf("%.2f", call.cost)
    end

    def calls
      @calls ||= @phone_bill.calls
    end

    def known_calls
      @known_calls ||= calls.inject([]) do |known, call|
        Contact.find(:number => call.number_called) ? known << call : known
      end
    end

    def unknown_calls
      calls - known_calls
    end

    def total
      @total ||= @phone_bill.total
    end

    def known_total
      @known_total ||= known_calls.inject(0) do |known_total, call|
        known_total += call.cost.to_f
      end
    end

    def unknown_total
      @unknown_total ||= @phone_bill.total - known_total
    end

    def user_total(user_name)
      user = User.find(:name => user_name)
      calls.inject(0) do |total, call|
        if Contact.find(:number => call.number_called, :user_id => user.id)
          total += call.cost.to_f
        else
          total
        end
      end
    end

    def users
      User.all.inject([]) do |users_hash, user|
        users_hash << { :name => user.name, :total => user_total(user.name) }
      end
    end
  end
end
