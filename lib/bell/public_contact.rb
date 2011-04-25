module Bell
  class PublicContact < Sequel::Model
    plugin :validation_helpers

    def validate
      super
      validates_unique(:number,
                       :message => Message.contact_number_taken(number))
      validates_format(/^\d{10}$/,
                       :number,
                       :message => Message.contact_number_bad_format(number))
      if UserContact.find(:number => number)
        errors.add(:number, Message.contact_number_taken(number))
      end
    end
  end
end
