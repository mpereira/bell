require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Bell::CliHandler do
  let(:args) { mock("args").as_null_object }
  let(:messenger) { mock("messenger") }
  let(:user_handler) { mock(Bell::UserHandler) }
  let(:cli_handler) { Bell::CliHandler.new(messenger) }

  context "when calling for an invalid resource" do
    it "shows the usage" do
      args.stub!(:first).and_return('foo')
      messenger.should_receive(:puts).with(Bell::Message.show_usage)
      cli_handler.run(args)
    end
  end

  context "when calling for the user resource" do
    it "forwards the arguments to the user handler" do
      args.stub!(:first).and_return('user')
      Bell::UserHandler.should_receive(:new).with(messenger).and_return(user_handler)
      user_handler.should_receive(:run)
      cli_handler.run(args)
    end
  end
end
