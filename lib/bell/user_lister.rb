module Bell
  class UserLister
    def initialize(output)
      @output = output
    end

    def list
      if User.empty?
        @output.puts OutputFormatter.no_created_users
      else
        list_users
      end
    end

    private
    def list_users
      @output.puts User.all.map(&:name)
    end
  end
end
