require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Bell::Commands::UserCommand do
  context "when initialized" do
    let(:user_command_route) do
      { :handler => 'users_handler', :action => nil, :params => {} }
    end

    it "has default values" do
      user_command = described_class.new
      user_command.route.should == user_command_route
    end
  end

  context "parsing 'create' commands" do
    context "without additional arguments" do
      let(:args) { %w[create] }

      it "raises ArgumentError" do
        lambda { described_class.new(args).parse }.should raise_error(ArgumentError)
      end
    end

    context "with one additional argument" do
      let(:args) { %w[create bob] }
      let(:user_command_route) do
        { :handler => 'users_handler',
          :action => 'create',
          :params => { :user => { :name => args.last } } }
      end

      it "assembles the right route" do
        user_command = described_class.new(args)
        user_command.parse
        user_command.route.should == user_command_route
      end
    end
  end

  context "parsing 'list' commands" do
    context "without additional arguments" do
      let(:args) { %w[list] }
      let(:user_command_route) do
        { :handler => 'users_handler',
          :action => 'list',
          :params => {} }
      end

      it "assembles the right route" do
        user_command = described_class.new(args)
        user_command.parse
        user_command.route.should == user_command_route
      end
    end
  end

  context "parsing 'remove' commands" do
    context "without additional arguments" do
      let(:args) { %w[remove] }

      it "raises ArgumentError" do
        lambda { described_class.new(args).parse }.should raise_error(ArgumentError)
      end
    end

    context "with one additional argument" do
      let(:args) { %w[remove bob] }
      let(:user_command_route) do
        { :handler => 'users_handler',
          :action => 'remove',
          :params => { :user => { :name => args.last } } }
      end

      it "assembles the right route" do
        user_command = described_class.new(args)
        user_command.parse
        user_command.route.should == user_command_route
      end
    end
  end

  context "parsing unknown commands" do
    let(:args) { %w[foo] }

    it "raises ArgumentError" do
      lambda { described_class.new(args).parse }.should raise_error(ArgumentError)
    end
  end
end
