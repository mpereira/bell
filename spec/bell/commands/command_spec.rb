require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Bell::Commands::Command do
  context "when initialized" do
    let(:command_route) { { :handler => nil, :action => nil, :params => {} } }

    it "has default values" do
      command = described_class.new
      command.route.should == command_route
    end
  end

  context "when parsing" do
    context "a user command" do
      let(:args) { mock("args").as_null_object }
      let(:user_command) { mock(Bell::Commands::UserCommand) }

      it "instantiates a user command and parses it" do
        args.stub!(:[]).with(0).and_return('user')
        Bell::Commands::UserCommand.should_receive(:new).and_return(user_command)
        user_command.should_receive(:parse)
        described_class.new(args).parse
      end
    end

    context "a contact command" do
      let(:args) { mock("args").as_null_object }
      let(:contact_command) { mock(Bell::Commands::ContactCommand) }

      it "instantiates a contact command and parses it" do
        args.stub!(:[]).with(0).and_return('contact')
        Bell::Commands::ContactCommand.should_receive(:new).and_return(contact_command)
        contact_command.should_receive(:parse)
        described_class.new(args).parse
      end
    end

    context "a report command" do
      let(:args) { mock("args").as_null_object }
      let(:contact_command) { mock(Bell::Commands::ContactCommand) }

      it "instantiates a report command and parses it" do
        args.stub!(:[]).with(0).and_return('contact')
        Bell::Commands::ContactCommand.should_receive(:new).and_return(contact_command)
        contact_command.should_receive(:parse)
        described_class.new(args).parse
      end
    end

    context "an implosion command" do
      let(:args) { mock("args").as_null_object }
      let(:contact_command) { mock(Bell::Commands::ContactCommand) }

      it "instantiates an implosion command and parses it" do
        args.stub!(:[]).with(0).and_return('contact')
        Bell::Commands::ContactCommand.should_receive(:new).and_return(contact_command)
        contact_command.should_receive(:parse)
        described_class.new(args).parse
      end
    end

    context "an unknown command" do
      let(:args) { ['foo'] }
      let(:contact_command) { mock(Bell::Commands::ContactCommand) }

      it "instantiates an implosion command and parses it" do
        lambda { described_class.new(args).parse }.
          should raise_error(ArgumentError, described_class::USAGE)
      end
    end
  end
end
