require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Bell::UsersHandler do
  let(:users_handler) { described_class }
  let(:user_created_message) { Bell::Message.user_created(params[:user][:name]) }
  let(:no_created_users_message) { Bell::Message.no_created_users }
  let(:user_already_exists_message) do
    Bell::Message.user_already_exists(params[:user][:name])
  end

  describe "#create" do
    let(:params) { { :user => { :name => 'bob' } } }

    context "when there is already a user with the given name" do
      it "shows the 'user already exists' message" do
        Bell::User.stub!(:find).with(:name => params[:user][:name]).and_return(true)
        users_handler.should_receive(:display).with(user_already_exists_message)
        users_handler.create(params)
      end
    end

    context "when there are no users with the given name" do
      it "creates the user" do
        Bell::User.stub!(:find).and_return(false)
        Bell::User.should_receive(:create).with(:name => params[:user][:name])
        users_handler.create(params)
      end

      it "shows the 'user created' message" do
        users_handler.should_receive(:display).with(user_created_message)
        users_handler.create(params)
      end
    end
  end

  describe "#list" do
    let(:params) { {} }

    context "when there are no created users" do
      it "shows the 'no created users' message" do
        Bell::User.stub!(:empty?).and_return(true)
        users_handler.should_receive(:display).with(no_created_users_message)
        users_handler.list(params)
      end
    end

    context "when there are created users" do
      let(:bob) { Bell::User.new(:name => 'bob') }
      let(:john) { Bell::User.new(:name => 'john') }

      it "shows the users' names" do
        Bell::User.stub!(:empty?).and_return(false)
        Bell::User.stub!(:all).and_return([bob, john])
        users_handler.should_receive(:display).with("bob\njohn")
        users_handler.list(params)
      end
    end
  end

  describe "#remove" do
    let(:params) { { :user => { :name => 'bob' } } }

    context "when there are no users with the given name" do
      let(:user_does_not_exist_message) do
        Bell::Message.user_does_not_exist(params[:user][:name])
      end

      it "shows the 'user does not exist' message" do
        Bell::User.stub!(:find).with(:name => params[:user][:name]).and_return(false)
        users_handler.should_receive(:display).with(user_does_not_exist_message)
        users_handler.remove(params)
      end
    end

    context "when there is a user with the given name" do
      let(:user) { mock(Bell::User, :name => 'bob').as_null_object }
      let(:user_removed_message) { Bell::Message.user_removed(user.name) }

      before do
        Bell::User.stub!(:find).and_return(user)
      end

      it "removes the user" do
        user.should_receive(:destroy)
        users_handler.remove(params)
      end

      it "shows the 'user removed' message" do
        users_handler.should_receive(:display).with(user_removed_message)
        users_handler.remove(params)
      end
    end
  end
end
