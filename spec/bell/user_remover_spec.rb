require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Bell::UserRemover do
  let(:output) { mock("output").as_null_object }
  let(:user_attributes) { { :name => 'murilo' } }
  let(:user) { Bell::User.create(:name => user_attributes[:name]) }
  let(:user_remover) { described_class.new(output) }

  context "when the given user name matches a user" do
    before :each do
      Bell::User.should_receive(:find).
        with(:name => user_attributes[:name]).and_return(user)
    end

    it "removes the user" do
      lambda { user_remover.remove(user_attributes) }.
        should change(Bell::User, :count).by(-1)
    end

    it "shows the 'user removed' message" do
      output.should_receive(:puts).
        with(Bell::OutputFormatter.user_removed(user_attributes[:name]))
      user_remover.remove(user_attributes)
    end
  end

  context "when the given user name doesn't match any users" do
    it "shows the 'user does not exist' message" do
      Bell::User.should_receive(:find).
        with(:name => user_attributes[:name]).and_return(false)
      output.should_receive(:puts).
        with(Bell::OutputFormatter.user_does_not_exist(user_attributes[:name]))
      user_remover.remove(user_attributes)
    end
  end
end
