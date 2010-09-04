require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Bell::UserLister do
  let(:args) { mock("args").as_null_object }
  let(:all_users) { mock("all_users") }
  let(:user_names) { mock("user_names") }
  let(:messenger) { mock("messenger") }
  let(:user_lister) { described_class.new(messenger) }

  context "when called with extra arguments" do
    it "raises UserListerArgumentError" do
      args.stub!(:length).and_return(1)
      lambda { user_lister.list!(args) }.
        should raise_error(Bell::Errors::UserListerArgumentError)
    end
  end

  context "when the database has no users" do
    it "tells the user that the database is empty" do
      args.stub!(:length).and_return(0)
      Bell::User.stub!(:empty?).and_return(true)
      messenger.should_receive(:puts).with(Bell::OutputFormatter.no_users_in_database)
      user_lister.list!(args)
    end
  end

  context "when the database has one or more" do
    it "prints the users' names" do
      args.stub!(:length).and_return(0)
      Bell::User.stub!(:empty?).and_return(false)
      messenger.should_receive(:puts).with(Bell::OutputFormatter.user_list)
      user_lister.list!(args)
    end
  end
end
