require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Bell::User::Handler do
  let(:args) { mock("args").as_null_object }
  let(:user_handler) { Bell::User::Handler.new(args) }
  let(:user_creator) { mock("User::Creator") }
  let(:actions) { user_handler.actions }
  let(:usage) { Bell::USAGE }

  describe "#valid_action?" do
    context "when given a valid action" do
      it "returns true" do
        args.stub!('[]').with(1).and_return('create')
        actions.stub!(:include?).with(args).and_return(true)
        user_handler.valid_action?.should be_true
      end
    end

    context "when given an invalid action" do
      it "returns false" do
        args.stub!('[]').with(1).and_return('foo')
        actions.stub!(:include?).with(args).and_return(false)
        user_handler.valid_action?.should be_false
      end
    end
  end

  context "handling an invalid action" do
    it "shows the usage" do
      user_handler.stub!(:valid_action?).and_return(false)
      $stdout.should_receive(:puts).with(usage)
      user_handler.parse_args
    end
  end

  context "handling the 'create' action" do
    it "creates a user creator instance" do
      args.stub!('[]').with(1).and_return('create')
      Bell::User::Creator.should_receive(:new).with(args).and_return(user_creator)
      user_creator.should_receive(:run)
      user_handler.parse_args
    end
  end
end
