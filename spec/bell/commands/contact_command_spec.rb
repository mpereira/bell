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

  context "parsing 'import' commands" do
    context "without additional arguments" do
      let(:args) { %w[import] }

      it "raises ArgumentError" do
        lambda { described_class.new(args).parse }.should raise_error(ArgumentError)
      end
    end

    context "with additional arguments" do
      context "when they are valid" do
        let(:args) { %w[import path/to/contacts_file.csv -u john] }
        let(:contact_command_route) do
          { :handler => 'contacts_handler',
            :action => 'import',
            :params => { :path => args[1], :user => { :name => args[3] } } }
        end

        it "assembles the right route" do
          contact_command = described_class.new(args)
          contact_command.parse
          contact_command.route.should == contact_command_route
        end
      end

      context "when there is arguments missing" do
        let(:args) { %w[import path/to/contacts_file.csv -u john] }
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
      let(:args) { %w[list -u bob] }
      let(:contact_command_route) do
        { :handler => 'contacts_handler',
          :action => 'list',
          :params => { :user => { :name => args[2] } } }
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
