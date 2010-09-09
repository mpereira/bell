require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Bell::UserLister do
  let(:messenger) { mock("messenger") }
  let(:user_lister) { described_class.new(messenger) }

  context "when there are no users created" do
    it "shows the 'no created users' message" do
      Bell::User.should_receive(:empty?).and_return(true)
      messenger.should_receive(:puts).with(Bell::OutputFormatter.no_created_users)
      user_lister.list
    end
  end

  context "when there are users created" do
    it "shows the 'no created users' message" do
      Bell::User.should_receive(:empty?).and_return(false)
      user_lister.should_receive(:list_users)
      user_lister.list
    end
  end
end
