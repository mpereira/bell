require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Bell::ContactCreator do
  let(:args) { mock("args").as_null_object }
  let(:messenger) { mock("messenger") }
  let(:user_does_not_exist) { mock("user_does_not_exist") }
  let(:contact_already_exists) { mock("contact_already_exists") }
  let(:contact_created) { mock("contact_created") }
  let(:user) { mock(Bell::User) }
  let(:contact) { mock(Bell::Contact) }
  let(:contact_creator) { described_class.new(messenger) }

  context "when the arguments passed are invalid" do
    it "raises ContactCreatorArgumentError" do
      contact_creator.stub!(:valid_contact_creation_args?).and_return(false)
      lambda { contact_creator.create!(args) }.
        should raise_error(Bell::Errors::ContactCreatorArgumentError)
    end
  end

  context "when the arguments passed are valid" do
    context "when the user passed as argument doesn't exist" do
      it "tells us that the user doesn't exist" do
        contact_creator.stub!(:valid_contact_creation_args?).and_return(true)
        Bell::User.stub!(:find).and_return(nil)
        Bell::OutputFormatter.stub!(:user_does_not_exist).and_return(user_does_not_exist)
        messenger.should_receive(:puts).with(user_does_not_exist)
        contact_creator.create!(args)
      end
    end

    context "when the user passed as argument exists" do
      context "when the contact passed as argument already exists" do
        it "tells us that the already exists" do
          contact_creator.stub!(:valid_contact_creation_args?).and_return(true)
          Bell::User.stub!(:find).and_return(user)
          Bell::Contact.stub!(:find).and_return(contact)
          Bell::OutputFormatter.stub!(:contact_already_exists).and_return(contact_already_exists)
          messenger.should_receive(:puts).with(contact_already_exists)
          contact_creator.create!(args)
        end
      end

      context "when the contact passed as argument doesn't exist" do
        it "creates the contact and tells us that it was created" do
          contact_creator.stub!(:valid_contact_creation_args?).and_return(true)
          Bell::User.stub!(:find).and_return(user)
          Bell::Contact.stub!(:find).and_return(nil)
          user.should_receive(:add_contact)
          Bell::OutputFormatter.stub!(:contact_created).and_return(contact_created)
          messenger.should_receive(:puts).with(contact_created)
          contact_creator.create!(args)
        end
      end
    end
  end
end
