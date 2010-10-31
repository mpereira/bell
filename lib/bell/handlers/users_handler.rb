module Bell::Handlers
  class UsersHandler
    include Bell::Displayable

    def self.create(params = {})
      if Bell::User.find(:name => params[:user][:name])
        display Bell::Message.user_already_exists(params[:user][:name])
      else
        Bell::User.create(:name => params[:user][:name])
        display Bell::Message.user_created(params[:user][:name])
      end
    end

    def self.rename(params = {})
      if user = Bell::User.find(:name => params[:user][:source_name])
        if Bell::User.find(:name => params[:user][:target_name])
          display Bell::Message.user_already_exists(params[:user][:target_name])
        else
          user.name = params[:user][:target_name]
          user.save
          display Bell::Message.user_renamed(params[:user])
        end
      else
        display Bell::Message.user_does_not_exist(params[:user][:source_name])
      end
    end

    def self.list(params = {})
      if Bell::User.empty?
        display Bell::Message.no_created_users
      else
        display formatted_user_list
      end
    end

    def self.remove(params = {})
      if user = Bell::User.find(:name => params[:user][:name])
        user.destroy
        display Bell::Message.user_removed(params[:user][:name])
      else
        display Bell::Message.user_does_not_exist(params[:user][:name])
      end
    end

    private
    def self.formatted_user_list
      Bell::User.all.map(&:name).join("\n")
    end
  end
end
