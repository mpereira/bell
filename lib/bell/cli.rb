module Bell
  module CLI
    #include Displayable

    def self.run(args)
      command = Command.new(args).build
      Dispatcher.dispatch(command.hash)
    rescue ArgumentError
      #display USAGE
    end
  end
end
