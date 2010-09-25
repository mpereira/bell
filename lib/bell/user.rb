module Bell
  class User < Sequel::Model
    one_to_many :contacts

    plugin :validation_helpers

    def after_destroy
      super
      contacts.each(&:delete)
    end

    def validate
      validates_unique :name
    end
  end
end
