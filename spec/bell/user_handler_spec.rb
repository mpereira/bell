require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Bell::UserHandler do
  let(:args) { mock("args").as_null_object }
  let(:user_handler) { Bell::UserHandler.new(args) }
  let(:user_creator) { mock(Bell::UserCreator) }
  let(:available_actions) { user_handler.available_actions }
  let(:messenger) { mock(Bell::Messenger) }

  describe "#valid_action?" do
    context "when given a valid action" do
      it "returns true" do
        args.stub!(:first).and_return('create')
        user_handler.valid_action?.should be_true
      end
    end

    context "when given an invalid action" do
      it "returns false" do
        args.stub!(:first).and_return('foo')
        user_handler.valid_action?.should be_false
      end
    end
  end

  context "handling an invalid action" do
    it "shows the usage" do
      user_handler.stub!(:valid_action?).and_return(false)
      user_handler.stub!(:messenger).and_return(messenger)
      messenger.should_receive(:show_usage)
      user_handler.run
    end
  end

  context "handling the 'create' action" do
    it "creates a user creator instance" do
      args.stub!(:first).and_return('create')
      user_handler.stub!(:valid_action?).and_return(true)
      Bell::UserCreator.should_receive(:new).with(args).and_return(user_creator)
      user_creator.should_receive(:run)
      user_handler.run
    end

    context "when the user is invalid" do
      it "shows the usage" do
        user_handler.stub!(:valid_action?).and_return(false)
        user_handler.stub!(:messenger).and_return(messenger)
        messenger.should_receive(:show_usage)
        user_handler.run
      end
    end
  end
end
