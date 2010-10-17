module Bell::Commands
  class UserCommand < Command
    def initialize(args = [])
      super(args)
      @handler = 'users_handler'
    end

    def build
      case @args[0]
      when 'create' then
        if @args[1]
          @action = 'create'
          @params = { :user => { :name => @args[1] } }
        else
          raise ArgumentError
        end
      when 'list' then
        @action = 'list'
      when 'remove' then
        if @args[1]
          @action = 'remove'
          @params = { :user => { :name => @args[1] } }
        else
          raise ArgumentError
        end
      else
        raise ArgumentError
      end

      self
    end
  end
end
