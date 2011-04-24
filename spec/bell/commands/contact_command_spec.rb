require File.expand_path(File.dirname(__FILE__) << '/../../spec_helper')

describe Bell::Commands::ContactCommand do
  describe ".initialize" do
    def contact_command_route(action)
      { :handler => 'contacts_handler', :action => action, :params => {} }
    end

    context "when given invalid actions" do
      it "raises ArgumentError" do
        lambda { described_class.new(%w[foo]).parse }.
          should raise_error(ArgumentError, described_class::USAGE)
      end
    end

    context "when giver valid actions" do
      it "sets the handler route key" do
        %w[import list].each do |action|
          contact_command = described_class.new([action])
          contact_command.route.should == contact_command_route(action)
        end
      end
    end
  end

  describe ".import" do
    context "when given no additional arguments" do
      it "raises ArgumentError" do
        lambda { described_class.new(%w[import]).parse }.
          should raise_error(ArgumentError, described_class::IMPORT_USAGE)
      end
    end

    context "when given valid arguments" do
      let(:path) { 'path/to/contacts_file.csv' }
      let(:user_name) { 'john' }
      let(:contact_command_route) do
        { :handler => 'contacts_handler',
          :action => 'import',
          :params => { :path => path, :user => { :name => user_name } } }
      end

      it "assembles the right route" do
        %w[-u --user].each do |user_name_flag|
          described_class.
            new(['import', path, user_name_flag, user_name]).
            parse.
            route.should == contact_command_route
        end
      end
    end
  end

  context "parsing 'list' commands" do
    context "without additional arguments" do
      let(:contact_command_route) do
        { :handler => 'contacts_handler',
          :action => 'list',
          :params => {} }
      end

      it "assembles the right route" do
        described_class.new(%w[list]).parse.route.should == contact_command_route
      end
    end

    context "when given valid user arguments" do
      context "when not asking for CSV" do
        let(:user_name) { 'john' }
        let(:contact_command_route) do
          { :handler => 'contacts_handler',
            :action => 'list',
            :params => { :user => { :name => user_name } } }
        end

        it "assembles the right route" do
          %w[-u --user].each do |user_name_flag|
            described_class.
              new(['list', user_name_flag, user_name]).
              parse.
              route.should == contact_command_route
          end
        end
      end

      context "when asking for CSV" do
        let(:user_name) { 'john' }
        let(:contact_command_route) do
          { :handler => 'contacts_handler',
            :action => 'list',
            :params => { :user => { :name => user_name }, :csv => true } }
        end

        it "assembles the right route" do
          %w[-u --user].each do |user_name_flag|
            described_class.
              new(['list', user_name_flag, user_name, '--csv']).
              parse.
              route.should == contact_command_route
          end
        end
      end
    end
  end

  context "parsing unknown commands" do
    it "raises ArgumentError" do
      lambda { described_class.new(%w[foo]).parse }.
        should raise_error(ArgumentError, described_class::USAGE)
    end
  end
end
