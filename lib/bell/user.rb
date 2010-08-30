module Bell
  class User < Sequel::Model
    one_to_many :contacts
  end
end
