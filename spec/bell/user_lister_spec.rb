require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Bell::UserLister do
  let(:args) { mock("args").as_null_object }
  let(:all_users) { mock("all_users") }
  let(:user_names) { mock("user_names") }
  let(:messenger) { mock("messenger") }
  let(:user_lister) { described_class.new(messenger) }

  context "when called with extra arguments" do
    it "shows the usage" do
      args.stub!(:length).and_return(1)
      messenger.should_receive(:puts).with(Bell::OutputFormatter.usage)
      user_lister.run(args)
    end
  end

  context "when the database has no users" do
    it "tells the user that the database is empty" do
      args.stub!(:length).and_return(0)
      Bell::User.stub!(:empty?).and_return(true)
      messenger.should_receive(:puts).with(Bell::OutputFormatter.no_users_in_database)
      user_lister.run(args)
    end
  end

  context "when the database has one or more" do
    it "prints the users' names" do
      args.stub!(:length).and_return(0)
      Bell::User.stub!(:empty?).and_return(false)
      Bell::User.should_receive(:all).and_return(all_users)
      all_users.should_receive(:map).and_return(user_names)
      messenger.should_receive(:puts).with(user_names)
      user_lister.run(args)
    end
  end
end
