# encoding: utf-8

module Bell
  class UserReport
    include Bell::Util::String

    def initialize(phone_bill, user_name)
      @phone_bill = phone_bill
      @user_name = user_name
    end

    def user
      Bell::User.find(:name => @user_name)
    end

    def calls
      @phone_bill.calls.inject([]) do |calls, call|
        if Bell::Contact.find(:user_id => user.id, :number => call.number_called)
          calls << call
        else
          calls
        end
      end
    end

    def total
      calls.inject(0) { |total, call| total += call.cost.to_f }
    end

    def to_s
      "#{formatted_header}\n#{formatted_contact_calls}\n\n#{formatted_total}"
    end

    private

    def formatted_header
      "Data".ljust(15) <<
      "Contato".ljust(20) <<
      "Número".ljust(15) <<
      "Horário".ljust(20) <<
      "Custo"
    end

    def contact_calls
      calls.inject([]) do |contact_calls, call|
        if contact = Bell::Contact.find(:number => call.number_called)
          contact_calls << { :contact => contact, :call => call }
        else
          contact_calls
        end
      end
    end

    def formatted_total
      "Total: R$ #{sprintf("%.2f", total)}"
    end

    def formatted_contact_name(contact_name)
      if contact_name.size > 20
        shortened_contact_name = contact_name[0, 15].rstrip.concat('...')
      else
        shortened_contact_name = contact_name
      end

      multibyte_characters = shortened_contact_name.size -
                               multibyte_length(shortened_contact_name)
      formatted_contact_name = shortened_contact_name.
                                 ljust(20 + multibyte_characters)
    end

    def formatted_contact_call(contact_call)
      contact = contact_call[:contact]
      call = contact_call[:call]


      call.date[0, 8].ljust(15) <<
      formatted_contact_name(contact.name) <<
      call.number_called.ljust(15) <<
      call.start_time.ljust(20) <<
      sprintf("%.2f", call.cost)
    end

    def formatted_contact_calls
      contact_calls.
        map { |contact_call| formatted_contact_call(contact_call) }.join("\n")
    end
  end
end
