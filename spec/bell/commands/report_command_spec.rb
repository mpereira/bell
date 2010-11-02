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

  context "parsing 'user_report' commands" do
    context "when given all necessary arguments" do
      let(:args) { %w[fatura.csv -u bob] }
      let(:report_command_route) do
        { :handler => 'reports_handler',
          :action => 'user_report',
          :params => { :path => args[0], :user => { :name => args[2] } } }
      end

      it "assembles the right route" do
        report_command = described_class.new(args)
        report_command.parse
        report_command.route.should == report_command_route
      end
    end

    context "with one missing argument" do
      let(:args) { %w[-u bob] }
      let(:args_with_one_missing_array) do
        args.dup.inject([]) { |args_with_one_missing, arg|
          args_with_one_missing << args.reject { |a| a == arg }
        }.each { |array| array.unshift('fatura.csv') }
      end

      it "raises ArgumentError" do
        lambda { described_class.new(args).parse }.
          should raise_error(ArgumentError, described_class::USER_REPORT_USAGE)
      end
    end
  end
end
