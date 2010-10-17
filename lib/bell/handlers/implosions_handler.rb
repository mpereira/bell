module Bell::Handlers
  class ImplosionsHandler
    include Bell::Displayable

    def self.implode(params = {})
      Bell.implode!
    end
  end
end
