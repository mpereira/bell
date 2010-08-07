require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Bell::UserCreator do
  let(:args) { mock("args").as_null_object }
  let(:user_creator) { described_class.new(args) }
  let(:user) { mock(Bell::User).as_null_object }
  let(:messenger) { mock(Bell::Messenger) }
  let(:usage) { Bell::USAGE }

  context "when no user name is passed" do
    it "shows the usage" do
      args.stub!(:length).and_return(0)
      $stdout.should_receive(:puts).with(usage)
      user_creator.run
    end
  end

  context "when the user name is passed together with other arguments" do
    it "shows the usage" do
      args.stub!(:length).and_return(2)
      $stdout.should_receive(:puts).with(usage)
      user_creator.run
    end
  end

  context "when just the user name is passed" do
    context "when the given user doesn't exist" do
      it "creates the user" do
        args.stub!(:length).and_return(1)
        user_creator.stub!(:messenger).and_return(messenger)
        Bell::User.should_receive(:new).with(args).and_return(user)
        user.should_receive(:exists?).and_return(false)
        user.should_receive(:create)
        messenger.should_receive(:notify_user_creation).with(user.name)
        user_creator.run
      end
    end

    context "when the given user exist" do
      it "shows a message saying that a user with that name exists" do
        args.stub!(:length).and_return(1)
        user_creator.stub!(:messenger).and_return(messenger)
        Bell::User.should_receive(:new).with(args).and_return(user)
        user.should_receive(:exists?).and_return(true)
        messenger.should_receive(:notify_user_existence).with(user.name)
        user_creator.run
      end
    end
  end
end
