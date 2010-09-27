module Bell
  class ReportHandler
    def initialize(output)
      @output = output
    end

    def handle(args)
      if args.length == 1
        ReportCreator.new(@output).create(args.first)
      else
        @output.puts USAGE
      end
    end
  end
end
