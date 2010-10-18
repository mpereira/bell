module Bell
  module CLI
    include Displayable

    def self.run(args)
      command = Commands::Command.new(args).parse
      Dispatcher.dispatch(command.route)
    rescue ArgumentError
      display USAGE
    end
  end
end
