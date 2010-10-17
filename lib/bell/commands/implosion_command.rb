module Bell::Commands
  class ImplosionCommand < Command
    def initialize(args = [])
      super(args)
      @handler = 'implosions_handler'
    end

    def build
      @action = 'implode'

      self
    end
  end
end
