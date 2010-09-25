require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Bell::ContactRemover do
  let(:output) { mock("output").as_null_object }
  let(:contact_attributes) { { :name => 'augusto' } }
  let(:contact) { mock(Bell::Contact).as_null_object }
  let(:contact_remover) { described_class.new(output) }

  context "when the given contact name matches a contact" do
    before :each do
      Bell::Contact.should_receive(:find).
        with(:name => contact_attributes[:name]).and_return(contact)
    end

    it "removes the contact" do
      contact.should_receive(:destroy)
      contact_remover.remove(contact_attributes)
    end

    it "shows the 'contact removed' message" do
      output.should_receive(:puts).
        with(Bell::OutputFormatter.contact_removed(contact_attributes[:name]))
      contact_remover.remove(contact_attributes)
    end
  end

  context "when the given contact name doesn't match any contacts" do
    it "shows the 'contact does not exist' message" do
      Bell::Contact.should_receive(:find).
        with(:name => contact_attributes[:name]).and_return(false)
      output.should_receive(:puts).
        with(Bell::OutputFormatter.contact_does_not_exist(contact_attributes[:name]))
      contact_remover.remove(contact_attributes)
    end
  end
end
