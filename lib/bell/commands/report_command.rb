module Bell::Commands
  class ReportCommand < Command
    def initialize(args = [])
      super(args)
      @handler = 'reports_handler'
    end

    def build
      @action = 'create'
      if @args[0]
        @params = { :path => @args[0] }
      else
        raise ArgumentError
      end

      self
    end
  end
end
