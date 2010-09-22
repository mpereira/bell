require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Bell::UserLister do
  let(:output) { mock("output") }
  let(:user_lister) { described_class.new(output) }

  context "when there are no users created" do
    it "shows the 'no created users' message" do
      Bell::User.should_receive(:empty?).and_return(true)
      output.should_receive(:puts).with(Bell::OutputFormatter.no_created_users)
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
