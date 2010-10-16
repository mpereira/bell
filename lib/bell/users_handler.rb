module Bell
  class UsersHandler
    include Displayable

    def self.create(params = {})
      if User.find(:name => params[:user][:name])
        display Message.user_already_exists(params[:user][:name])
      else
        User.create(:name => params[:user][:name])
        display Message.user_created(params[:user][:name])
      end
    end

    def self.list(params = {})
      if User.empty?
        display Message.no_created_users
      else
        display formatted_user_list
      end
    end

    def self.remove(params = {})
      if user = User.find(:name => params[:user][:name])
        user.destroy
        display Message.user_removed(params[:user][:name])
      else
        display Message.user_does_not_exist(params[:user][:name])
      end
    end

    private
    def self.formatted_user_list
      User.all.map(&:name).join("\n")
    end
  end
end
