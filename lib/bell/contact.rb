module Bell
  class Contact < Sequel::Model
    many_to_one :user

    plugin :validation_helpers

    def validate
      validates_unique [:name, :user_id]
      validates_format /^[0-9]+$/, :number
      validates_exact_length 10, :number
    end
  end
end
