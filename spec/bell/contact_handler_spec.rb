require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Bell::ContactHandler do
  let(:output) { mock("output") }
  let(:contact_creator) { mock(Bell::ContactCreator) }
  let(:contact_lister) { mock(Bell::ContactLister) }
  let(:contact_remover) { mock(Bell::ContactRemover) }
  let(:contact_handler) { described_class.new(output) }

  context "when given an invalid action" do
    let(:invalid_action) { %w[foo] }

    it "shows the usage" do
      output.should_receive(:puts).with(Bell::USAGE)
      contact_handler.handle(invalid_action)
    end
  end

  context "when given the 'create' action" do
    context "with valid arguments" do
      let(:valid_create_action) { %w[create augusto -n 1234123412 -u murilo] }

      it "forwards the arguments to the contact creator" do
        Bell::ContactCreator.should_receive(:new).
          with(output).and_return(contact_creator)
        contact_creator.should_receive(:create)
        contact_handler.handle(valid_create_action)
      end
    end

    context "with invalid arguments" do
      let(:invalid_create_action) { %w[create augusto n 1234123412 u murilo] }

      it "shows the usage" do
        output.should_receive(:puts).with(Bell::USAGE)
        contact_handler.handle(invalid_create_action)
      end
    end
  end

  context "when given the 'list' action" do
    context "with valid arguments" do
      context "when not specifying a user" do
        let(:valid_create_action) { %w[list] }

        it "forwards the arguments to the contact lister" do
          Bell::ContactLister.should_receive(:new).
            with(output).and_return(contact_lister)
          contact_lister.should_receive(:list).with({})
          contact_handler.handle(valid_create_action)
        end
      end

      context "when specifying a user" do
        let(:valid_create_action) { %w[list murilo] }

        it "forwards the arguments to the contact lister" do
          Bell::ContactLister.should_receive(:new).
            with(output).and_return(contact_lister)
          contact_lister.should_receive(:list).with(:name => 'murilo')
          contact_handler.handle(valid_create_action)
        end
      end
    end

    context "with invalid arguments" do
      let(:invalid_list_action) { %w[list murilo foo] }

      it "shows the usage" do
        output.should_receive(:puts).with(Bell::USAGE)
        contact_handler.handle(invalid_list_action)
      end
    end
  end

  context "when given the 'remove' action" do
    context "with valid arguments" do
      let(:valid_remove_action) { %w[remove augusto] }

      it "forwards the arguments to the contact creator" do
        Bell::ContactRemover.should_receive(:new).
          with(output).and_return(contact_creator)
        contact_creator.should_receive(:remove)
        contact_handler.handle(valid_remove_action)
      end
    end

    context "with invalid arguments" do
      let(:invalid_remove_action) { %w[remove foo bar] }

      it "shows the usage" do
        output.should_receive(:puts).with(Bell::USAGE)
        contact_handler.handle(invalid_remove_action)
      end
    end
  end

end
