module Bell
  class Contact < Sequel::Model
    many_to_one :user

    plugin :validation_helpers

    def validate
      super
      validates_unique [:name, :user_id],
        :message => Message.contact_name_taken(self.name)
      validates_unique :number,
        :message => Message.contact_number_taken(self.number)
      validates_format /^[0-9]+$/, :number,
        :message => Message.bad_format_for_contact_number(self.number)
      validates_exact_length 10, :number,
        :message => Message.bad_format_for_contact_number(self.number)
    end
  end
end
