require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Bell::ContactLister do
  let(:args) { mock("args").as_null_object }
  let(:user_name) { mock("user_name") }
  let(:user) { mock(Bell::User) }
  let(:messenger) { mock("messenger").as_null_object }
  let(:contact_lister) { described_class.new(messenger) }

  context "when called with extra arguments" do
    it "raises ContactListerArgumentError" do
      args.stub!(:length).and_return(2)
      lambda { contact_lister.list!(args) }.
        should raise_error(Bell::Errors::ContactListerArgumentError)
    end
  end

  context "listing all contacts" do
    context "when the database has no contacts" do
      it "tells us that the database is empty" do
        args.stub!(:length).and_return(0)
        Bell::Contact.stub_chain(:all, :empty?).and_return(true)
        messenger.should_receive(:puts).
          with(Bell::OutputFormatter.no_contacts_in_database)
        contact_lister.list!(args)
      end
    end

    context "when the database has contacts" do
      it "calls #list_contacts" do
        args.stub!(:length).and_return(0)
        Bell::Contact.stub_chain(:all, :empty?).and_return(false)
        contact_lister.should_receive(:list_contacts).with(Bell::Contact.all)
        contact_lister.list!(args)
      end
    end
  end

  context "listing contacts from a given user" do
    context "when the database has contacts" do
      it "prints the contacts' names" do
        args.stub!(:length).and_return(1)
        Bell::User.stub!(:find).and_return(user)
        contact_lister.should_receive(:list_user_contacts).with(user)
        contact_lister.list!(args)
      end
    end

    context "when the database has no contacts" do
      it "shows the usage for user listing" do
        args.stub!(:length).and_return(1)
        args.stub!(:first).and_return(user_name)
        Bell::User.stub!(:find).and_return(nil)
        messenger.should_receive(:puts).
          with(Bell::OutputFormatter.user_does_not_exist(user_name))
        contact_lister.list!(args)
      end
    end
  end
end
