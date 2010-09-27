require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Bell::ReportHandler do
  let(:output) { mock("output") }
  let(:report_creator) { mock(Bell::ReportCreator) }
  let(:report_handler) { described_class.new(output) }

  context "when given an invalid number of arguments" do
    let(:invalid_arguments) { %w[foo bar] }

    it "shows the usage" do
      output.should_receive(:puts).with(Bell::USAGE)
      report_handler.handle(invalid_arguments)
    end
  end


  context "when given one argument" do
    let(:valid_arguments) { %w[foo] }

    it "shows the usage" do
      Bell::ReportCreator.should_receive(:new).
        with(output).and_return(report_creator)
      report_creator.should_receive(:create)
      report_handler.handle(valid_arguments)
    end
  end
end
