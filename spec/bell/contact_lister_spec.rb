require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Bell::ContactLister do
  let(:output) { mock("output").as_null_object }
  let(:user) { mock(Bell::User).as_null_object }
  let(:contact_lister) { described_class.new(output) }

  context "when given an empty hash" do
    let(:empty_hash) { {} }

    context "when there are no created contacts" do
      it "shows the 'no contacts created' message" do
        Bell::Contact.should_receive(:empty?).and_return(true)
        output.should_receive(:puts).
          with(Bell::OutputFormatter.no_contacts_created)
        contact_lister.list(empty_hash)
      end
    end

    context "when there are created contacts" do
      it "lists all contacts" do
        Bell::Contact.should_receive(:empty?).and_return(false)
        contact_lister.should_receive(:list_contacts).with(Bell::Contact.all)
        contact_lister.list(empty_hash)
      end
    end
  end

  context "when given a user name" do
    let(:user_attributes) { { :name => 'murilo' } }

    context "when the user exists" do
      it "lists the user contacts" do
        Bell::User.should_receive(:find).and_return(user)
        contact_lister.should_receive(:list_user_contacts).with(user)
        contact_lister.list(user_attributes)
      end
    end

    context "when there are created contacts" do
      it "shows the 'no contacts created' message" do
        Bell::User.should_receive(:find).and_return(nil)
        output.should_receive(:puts).
          with(Bell::OutputFormatter.user_does_not_exist('murilo'))
        contact_lister.list(user_attributes)
      end
    end
  end
end
