require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Bell::User::Creator do
  let(:args) { mock("args").as_null_object }
  let(:user_creator) { described_class.new(args) }
  let(:usage) { Bell::USAGE }

  describe "#user_exists?" do
    context "when given user exists" do
      it "returns true" do
        File.should_receive(:exists?).with(
          user_creator.data_file('murilo')
        ).and_return(true)
        user_creator.user_exists?('murilo').should be_true
      end
    end

    context "when given user doesn't exist" do
      it "returns false" do
        File.should_receive(:exists?).with(
          user_creator.data_file('murilo')
        ).and_return(false)
        user_creator.user_exists?('murilo').should be_false
      end
    end
  end

  context "when no user name is passed" do
    it "shows the usage" do
      args.stub!(:length).and_return(0)
      $stdout.should_receive(:puts).with(usage)
      user_creator.run
    end
  end

  context "when the user name is passed together with other arguments" do
    it "shows the usage" do
      args.stub!(:length).and_return(2)
      $stdout.should_receive(:puts).with(usage)
      user_creator.run
    end
  end

  context "when just the user name is passed" do
    context "when the given user with isn't taken" do
      it "creates the user" do
        args.stub!(:length).and_return(1)
        user_creator.stub!(:user_exists?).with(args).and_return(false)
        user_creator.should_receive(:create).with(args)
        user_creator.run
      end
    end
  end
end
