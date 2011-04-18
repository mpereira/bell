require File.expand_path(File.dirname(__FILE__) << '/../../spec_helper')

describe Bell::Commands::ImplosionCommand do
  context "when initialized" do
    let(:implosion_command_route) do
      { :handler => 'implosions_handler', :action => nil, :params => {} }
    end

    it "has default values" do
      implosion_command = described_class.new
      implosion_command.route.should == implosion_command_route
    end
  end

  context "parsing" do
    context "without additional arguments" do
      let(:args) { %w[path/to/fatura.csv] }
      let(:implosion_command_route) do
        { :handler => 'implosions_handler',
          :action => 'implode',
          :params => {} }
      end

      it "assembles the right route" do
        implosion_command = described_class.new(args)
        implosion_command.parse
        implosion_command.route.should == implosion_command_route
      end
    end
  end
end
