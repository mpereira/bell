require File.expand_path('../../../spec_helper', __FILE__)

describe Bell::Commands::Command do
  context "when parsing" do
    context "a user command" do
      let(:args) { %w[user] }
      let(:user_command) { mock(Bell::Commands::UserCommand) }

      it "instantiates a user command and parses it" do
        Bell::Commands::UserCommand.should_receive(:new).and_return(user_command)
        user_command.should_receive(:parse)
        described_class.new(args).parse
      end
    end

    context "a contact command" do
      let(:args) { %w[contact] }
      let(:contact_command) { mock(Bell::Commands::ContactCommand) }

      it "instantiates a contact command and parses it" do
        Bell::Commands::ContactCommand.should_receive(:new).and_return(contact_command)
        contact_command.should_receive(:parse)
        described_class.new(args).parse
      end
    end

    context "a report command" do
      let(:args) { %w[report] }
      let(:report_command) { mock(Bell::Commands::ReportCommand) }

      it "instantiates a report command and parses it" do
        Bell::Commands::ReportCommand.should_receive(:new).and_return(report_command)
        report_command.should_receive(:parse)
        described_class.new(args).parse
      end
    end

    context "an implosion command" do
      let(:args) { %w[implode] }
      let(:implosion_command) { mock(Bell::Commands::ImplosionCommand) }

      it "instantiates an implosion command and parses it" do
        Bell::Commands::ImplosionCommand.should_receive(:new).and_return(implosion_command)
        implosion_command.should_receive(:parse)
        described_class.new(args).parse
      end
    end

    context "an unknown command" do
      let(:args) { %w[foo] }
      let(:contact_command) { mock(Bell::Commands::ContactCommand) }

      it "instantiates an implosion command and parses it" do
        lambda { described_class.new(args).parse }.
          should raise_error(ArgumentError, described_class::USAGE)
      end
    end
  end
end
