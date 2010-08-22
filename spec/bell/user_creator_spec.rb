require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Bell::UserCreator do
  let(:args) { mock("args").as_null_object }
  let(:messenger) { mock("messenger") }
  let(:user) { mock(Bell::User) }
  let(:user_name) { mock("user_name") }
  let(:user_creator) { described_class.new(messenger) }

  context "when no user name is passed" do
    it "shows the usage" do
      args.stub!(:length).and_return(0)
      messenger.should_receive(:puts).with(Bell::Messenger.show_usage)
      user_creator.run(args)
    end
  end

  context "when the user name is passed together with other arguments" do
    it "shows the usage" do
      args.stub!(:length).and_return(2)
      messenger.should_receive(:puts).with(Bell::Messenger.show_usage)
      user_creator.run(args)
    end
  end

  context "when just the user name is passed" do
    context "when the given user doesn't exist" do
      it "creates the user" do
        args.stub!(:length).and_return(1)
        args.stub!(:first).and_return(user_name)
        Bell::User.stub!(:[]).with(:name => user_name).and_return(nil)
        messenger.should_receive(:puts).with(Bell::Messenger.notify_user_creation(user_name))
        user_creator.run(args)
      end
    end

    context "when the given user exist" do
      it "shows a message saying that a user with that name exists" do
        args.stub!(:length).and_return(1)
        args.stub!(:first).and_return(user_name)
        Bell::User.stub!(:[]).with(:name => user_name).and_return(user)
        messenger.should_receive(:puts).with(Bell::Messenger.notify_user_existence(user_name))
        user_creator.run(args)
      end
    end
  end
end
