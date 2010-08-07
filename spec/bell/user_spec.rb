require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Bell::User do
  let(:name) { mock("name").as_null_object }
  let(:user) { described_class.new(name) }

  describe "#exists?" do
    context "when given user exists" do
      it "returns true" do
        File.should_receive(:exists?).with(user.data_file).and_return(true)
        user.exists?.should be_true
      end
    end

    context "when given user doesn't exist" do
      it "returns false" do
        File.should_receive(:exists?).with(user.data_file).and_return(false)
        user.exists?.should be_false
      end
    end
  end

  describe "#create" do
    it "creates the user" do
      FileUtils.should_receive(:touch).with(user.data_file)
      user.create
    end
  end
end
