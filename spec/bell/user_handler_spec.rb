require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Bell::UserHandler do
  let(:args) { mock("args").as_null_object }
  let(:messenger) { mock(Bell::Messenger) }
  let(:user_creator) { mock(Bell::UserCreator) }
  let(:user_handler) { Bell::UserHandler.new(messenger) }

  context "handling an invalid action" do
    it "shows the usage" do
      args.stub!(:first).and_return('foo')
      messenger.should_receive(:puts).with(Bell::Messenger.show_usage)
      user_handler.run(args)
    end
  end

  context "handling the 'create' action" do
    it "creates a user creator instance" do
      args.stub!(:first).and_return('create')
      Bell::UserCreator.should_receive(:new).with(messenger).and_return(user_creator)
      user_creator.should_receive(:run)
      user_handler.run(args)
    end
  end
end
