module Bell
  class Contact < Sequel::Model
    many_to_one :user
  end
end
