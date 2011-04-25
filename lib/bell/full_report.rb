# encoding: utf-8

module Bell
  class FullReport
    def initialize(phone_bill)
      @phone_bill = phone_bill
    end

    def to_s
      "[resumo]
       #{formatted_total}
       #{formatted_known_total}
       #{formatted_public_total}
       #{formatted_unknown_total}
       #{formatted_fees_total}

       [usuários]
       #{users.map { |user| %{#{formatted_user(user)}} }.join("\n")}

       [ligações públicas]
       #{public_calls.map do |hash|
         %{#{formatted_call(hash[:call], :contact => hash[:contact])}}
       end.join("\n")}

       [ligações desconhecidas]
       #{unknown_calls.map do |call|
         %{#{formatted_call(call)}}
       end.join("\n")}".gsub(/^\ {7,}/, '')
    end

    private

    def formatted_total
      %{#{"Total:"}}.ljust(25) << sprintf("%.2f", total)
    end

    def formatted_known_total
      %{#{"Usuários:"}}.ljust(25) << sprintf("%.2f", known_total)
    end

    def formatted_public_total
      %{#{"Públicas:"}}.ljust(25) << sprintf("%.2f", public_total)
    end

    def formatted_unknown_total
      %{#{"Desconhecidas:"}}.ljust(25) << sprintf("%.2f", unknown_total)
    end

    def formatted_fees_total
      %{#{"Taxas:"}}.ljust(25) << sprintf("%.2f", fees_total)
    end

    def formatted_user(user)
      %{#{user[:name]}}.ljust(25) << sprintf("%.2f", user[:total])
    end

    def formatted_call(call, options = {})
      contact = call.number_called << if options[:contact]
        " (#{options[:contact].name})"
      else
        ''
      end
      time = call.start_time.to_s
      date = call.date[0, 8].to_s
      cost = sprintf("%.2f", call.cost)
      contact.ljust(30) << if time.empty?
        date.empty? ? ' ' * 20 : ' ' * 10 << "#{date}  "
      else
        date.empty? ? ' ' * 12 << "#{time}" : "#{time}  #{date}  "
      end << cost
    end

    def calls
      @calls ||= @phone_bill.calls
    end

    def fees
      @fees ||= @phone_bill.fees
    end

    def known_calls
      @known_calls ||= calls.inject([]) do |memo, call|
        Contact.find(:number => call.number_called) ? memo << call : memo
      end
    end

    def public_calls
      @public_calls ||= calls.inject([]) do |memo, call|
        if contact = PublicContact.find(:number => call.number_called)
          memo << { :call => call, :contact => contact }
        else
          memo
        end
      end
    end

    def unknown_calls
      calls - (public_calls.map { |c| c[:call] } + known_calls)
    end

    def fees_total
      @fees_total ||= fees.inject(0) { |memo, call| memo += call.cost.to_f }
    end

    def total
      @total ||= @phone_bill.total
    end

    def known_total
      @known_total ||= known_calls.inject(0) do |memo, call|
        memo += call.cost.to_f
      end
    end

    def public_total
      @public_total ||= public_calls.inject(0) do |memo, hash|
        memo += hash[:call].cost.to_f
      end
    end

    def unknown_total
      @unknown_total ||= unknown_calls.inject(0) do |memo, call|
        memo += call.cost.to_f
      end
    end

    def user_total(user_name)
      user = User.find(:name => user_name)
      subtotal = calls.inject(0) do |total, call|
        if Contact.find(:number => call.number_called, :user_id => user.id)
          total += call.cost.to_f
        else
          total
        end
      end
      subtotal + (unknown_total + fees_total) / User.all.size
    end

    def users
      User.all.inject([]) do |users_hash, user|
        users_hash << { :name => user.name, :total => user_total(user.name) }
      end
    end
  end
end
