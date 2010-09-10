require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Bell::ContactCreator do
  let(:messenger) { mock("messenger").as_null_object }
  let(:contact_creator) { described_class.new(messenger) }
  let(:user) { Bell::User.new(:name => 'murilo') }
  let(:contact) do
    Bell::Contact.new(:name => 'augusto', :number => '1234123412', :user_id => 1)
  end
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
      it "creates the contact" do
        user.save
        lambda { contact.save }.should change(Bell::Contact, :count).by(1)
        contact_creator.create(contact_attributes)
      end
    end
  end
end
