module Bell
  class ImplosionsHandler
    include Displayable

    def self.implode(params = {})
      Bell.implode!
    end
  end
end
