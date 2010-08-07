require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Bell::CliHandler do
  let(:args) { mock("args") }
  let(:user_args) { mock("user_args") }
  let(:cli_handler) { Bell::CliHandler.new(args) }
  let(:messenger) { mock(Bell::Messenger) }
  let(:user_handler) { mock(Bell::UserHandler) }

  context "when calling for an invalid resource" do
    it "shows the usage" do
      args.stub!(:first).and_return('foo')
      cli_handler.stub!(:messenger).and_return(messenger)
      messenger.should_receive(:show_usage)
      cli_handler.run
    end
  end

  context "when calling for the user resource" do
    it "forwards the arguments to the user handler" do
      args.stub!(:first).and_return('user')
      args.should_receive(:[]).with(1..-1).and_return(user_args)
      Bell::UserHandler.should_receive(:new).with(user_args).and_return(user_handler)
      user_handler.should_receive(:run)
      cli_handler.run
    end
  end
end
