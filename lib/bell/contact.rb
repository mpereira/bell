module Bell
  class Contact < Sequel::Model
    many_to_one :user

    plugin :validation_helpers

    def validate
      validates_unique [:name, :user_id]
    end
  end
end
