module Bell
  class Dispatcher
    include Util::String

    def self.dispatch(command)
      Object.
        const_get(:Bell).
        const_get(:Handlers).
        const_get(camelize(command[:handler])).
        send(command[:action], command[:params])
    end
  end
end
