require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Bell::CliHandler do
  let(:output) { mock("output") }
  let(:user_handler) { mock(Bell::UserHandler) }
  let(:contact_handler) { mock(Bell::ContactHandler) }
  let(:cli_handler) { described_class.new(output) }

  context "when given an invalid resource" do
    let(:invalid_resource) { %w[foo] }

    it "shows the usage" do
      output.should_receive(:puts).with(Bell::USAGE)
      cli_handler.handle!(invalid_resource)
    end
  end

  context "when given the 'user' resource" do
    let(:user_resource) { %w[user] }

    it "forwards the arguments to the user handler" do
      Bell::UserHandler.should_receive(:new).with(output).and_return(user_handler)
      user_handler.should_receive(:handle!)
      cli_handler.handle!(user_resource)
    end
  end

  context "when calling for the 'contact' resource" do
    let(:contact_resource) { %w[contact] }

    it "forwards the arguments to the contact handler" do
      Bell::ContactHandler.should_receive(:new).with(output).and_return(contact_handler)
      contact_handler.should_receive(:handle!)
      cli_handler.handle!(contact_resource)
    end
  end
end
