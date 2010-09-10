require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Bell::ContactCreator do
  let(:messenger) { mock("messenger").as_null_object }
  let(:contact_creator) { described_class.new(messenger) }
  let(:user) { mock(Bell::User).as_null_object }
  let(:contact) { mock(Bell::Contact).as_null_object }
  let(:contact_attributes) do
    { :contact => { :name => 'augusto', :number => '1234123412' },
      :user => { :name => 'murilo' }
    }
  end

  context "when the given user doesn't exist" do
    it "shows the 'user does not exist' message" do
      Bell::User.should_receive(:find).and_return(nil)
      messenger.should_receive(:puts).
        with(Bell::OutputFormatter.user_does_not_exist('murilo'))
      contact_creator.create(contact_attributes)
    end
  end

  context "when the given user exists" do
    context "when the contact doesn't have validation errors" do
      before do
        Bell::User.should_receive(:find).and_return(user)
        Bell::Contact.should_receive(:new).and_return(contact)
      end

      it "creates the contact" do
        contact.should_receive(:save)
        contact_creator.create(contact_attributes)
      end

      it "shows the 'contact created' message" do
        messenger.should_receive(:puts).
          with(Bell::OutputFormatter.contact_created(contact))
        contact_creator.create(contact_attributes)
      end
    end
  end
end
