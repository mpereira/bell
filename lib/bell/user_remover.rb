module Bell
  class UserRemover
    def initialize(output)
      @output = output
    end

    def remove(user_attributes)
      if @user = User.find(:name => user_attributes[:name])
        @user.destroy
        @output.puts OutputFormatter.user_removed(user_attributes[:name])
      else
        @output.puts OutputFormatter.user_does_not_exist(user_attributes[:name])
      end
    end

    protected
    class << self
      def valid_args?(args)
        args.length == 1
      end

      def extract_attributes(args)
        { :name => args.first }
      end
    end
  end
end
