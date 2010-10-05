module Bell

  class Dispatcher
  include Util
    def self.dispatch(command)
      Object.
        const_get(command[:handler].camelize).
        send(command[:action], :params => command[:params])
    end
  end
end
