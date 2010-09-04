require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Bell::CliHandler do
  let(:args) { mock("args").as_null_object }
  let(:messenger) { mock("messenger").as_null_object }
  let(:user_handler) { mock(Bell::UserHandler) }
  let(:contact_handler) { mock(Bell::ContactHandler) }
  let(:cli_handler) { described_class.new(messenger) }

  context "when calling for an invalid resource" do
    it "raises CliHandlerArgumentError" do
      args.stub!(:first).and_return('foo')
      lambda { cli_handler.handle!(args) }.
        should raise_error(Bell::Errors::CliHandlerArgumentError)
    end
  end

  context "when calling for the user resource" do
    it "forwards the arguments to the user handler" do
      args.stub!(:first).and_return('user')
      Bell::UserHandler.should_receive(:new).with(messenger).and_return(user_handler)
      user_handler.should_receive(:handle!)
      cli_handler.handle!(args)
    end
  end

  context "when calling for the contact resource" do
    it "forwards the arguments to the contact handler" do
      args.stub!(:first).and_return('contact')
      Bell::ContactHandler.should_receive(:new).with(messenger).and_return(contact_handler)
      contact_handler.should_receive(:handle!)
      cli_handler.handle!(args)
    end
  end
end
