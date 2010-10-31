require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Bell::Commands::ReportCommand do
  context "when initialized" do
    let(:report_command_route) do
      { :handler => 'reports_handler', :action => nil, :params => {} }
    end

    it "has default values" do
      report_command = described_class.new
      report_command.route.should == report_command_route
    end
  end

  context "parsing 'full_report' commands" do
    context "with additional arguments" do
      let(:args) { %w[fatura.csv] }
      let(:report_command_route) do
        { :handler => 'reports_handler',
          :action => 'full_report',
          :params => { :path => args[0] } }
      end

      it "assembles the right route" do
        report_command = described_class.new(args)
        report_command.parse
        report_command.route.should == report_command_route
      end
    end

    context "without additional arguments" do
      let(:args) { %w[] }

      it "raises ArgumentError" do
        lambda { described_class.new(args).parse }.
          should raise_error(ArgumentError, described_class::FULL_REPORT_USAGE)
      end
    end
  end
end
