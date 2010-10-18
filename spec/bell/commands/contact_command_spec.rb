require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Bell::Commands::ContactCommand do
  context "when initialized" do
    let(:contact_command_route) do
      { :handler => 'contacts_handler', :action => nil, :params => {} }
    end

    it "has default values" do
      contact_command = described_class.new
      contact_command.route.should == contact_command_route
    end
  end

  context "parsing 'create' commands" do
    context "without additional arguments" do
      let(:args) { %w[create] }

      it "raises ArgumentError" do
        lambda { described_class.new(args).parse }.should raise_error(ArgumentError)
      end
    end

    context "with additional arguments" do
      context "when they are valid" do
        let(:args) { %w[create bob -u john -n 1234123412] }
        let(:contact_command_route) do
          { :handler => 'contacts_handler',
            :action => 'create',
            :params => { :contact => { :name => args[1], :number => args[5] },
                         :user => { :name => args[3] } } }
          { :handler => 'contacts_handler',
            :action => 'create',
            :params => { :contact => { :name => args[1], :number => args[5] },
                         :user => { :name => args[3] } } }
        end

        it "assembles the right route" do
          contact_command = described_class.new(args)
          contact_command.parse
          contact_command.route.should == contact_command_route
        end
      end

      context "when there is arguments missing" do
        let(:args) { %w[create bob -u john -n 1234123412] }
        let(:args_with_one_missing_array) do
          args.dup.inject([]) do |args_with_one_missing, arg|
            args_with_one_missing << args.reject { |a| a == arg }
          end
        end

        it "raises ArgumentError" do
          args_with_one_missing_array.each do |args_with_one_missing|
            lambda { described_class.new(args_with_one_missing).parse }.
              should raise_error(ArgumentError)
          end
        end
      end
    end
  end

  context "parsing 'list' commands" do
    context "without additional arguments" do
      let(:args) { %w[list] }
      let(:contact_command_route) do
        { :handler => 'contacts_handler',
          :action => 'list',
          :params => {} }
      end

      it "assembles the right route" do
        contact_command = described_class.new(args)
        contact_command.parse
        contact_command.route.should == contact_command_route
      end
    end

    context "with an user name as argument" do
      let(:args) { %w[list bob] }
      let(:contact_command_route) do
        { :handler => 'contacts_handler',
          :action => 'list',
          :params => { :user => { :name => args[1] } } }
      end

      it "assembles the right route" do
        contact_command = described_class.new(args)
        contact_command.parse
        contact_command.route.should == contact_command_route
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
      let(:contact_command_route) do
        { :handler => 'contacts_handler',
          :action => 'remove',
          :params => { :contact => { :name => args.last } } }
      end

      it "assembles the right route" do
        contact_command = described_class.new(args)
        contact_command.parse
        contact_command.route.should == contact_command_route
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
