require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Bell::UserCreator do
  let(:messenger) { mock("messenger").as_null_object }
  let(:user_attributes) { { :name => 'murilo' } }
  let(:user_creator) { described_class.new(messenger) }

  context "when a user with the user name passed exists" do
    it "shows the 'user already exists' message" do
      Bell::User.should_receive(:find).
        with(:name => user_attributes[:name]).and_return(true)
      messenger.should_receive(:puts).
        with(Bell::OutputFormatter.user_already_exists(user_attributes[:name]))
      user_creator.create(user_attributes)
    end
  end

  context "when no users with the user name passed exist" do
    before :each do
      Bell::User.should_receive(:find).
        with(:name => user_attributes[:name]).and_return(false)
    end

    it "creates the user" do
      Bell::User.should_receive(:create).with(:name => user_attributes[:name])
      user_creator.create(user_attributes)
    end

    it "shows the 'user created' message" do
      messenger.should_receive(:puts).
        with(Bell::OutputFormatter.user_created(user_attributes[:name]))
      user_creator.create(user_attributes)
    end
  end
end
