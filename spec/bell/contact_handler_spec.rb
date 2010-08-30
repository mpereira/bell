require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Bell::ContactHandler do
  let(:args) { mock("args").as_null_object }
  let(:messenger) { mock("messenger") }
  let(:contact_creator) { mock(Bell::ContactCreator) }
  let(:contact_lister) { mock(Bell::ContactLister) }
  let(:contact_handler) { described_class.new(messenger) }

  context "handling an invalid action" do
    it "shows the usage" do
      args.stub!(:first).and_return('foo')
      messenger.should_receive(:puts).with(Bell::OutputFormatter.usage)
      contact_handler.run(args)
    end
  end

  context "handling the 'create' action" do
    it "creates a contact creator instance to handle the creation" do
      args.stub!(:first).and_return('create')
      Bell::ContactCreator.should_receive(:new).with(messenger).and_return(contact_creator)
      contact_creator.should_receive(:create)
      contact_handler.run(args)
    end
  end

  context "handling the 'list' action" do
    it "creates a contact lister instance to handle the listing" do
      args.stub!(:first).and_return('list')
      Bell::ContactLister.should_receive(:new).with(messenger).and_return(contact_lister)
      contact_lister.should_receive(:list)
      contact_handler.run(args)
    end
  end
end
