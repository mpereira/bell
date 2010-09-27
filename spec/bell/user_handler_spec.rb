require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Bell::UserHandler do
  let(:output) { mock("output") }
  let(:user_creator) { mock(Bell::UserCreator) }
  let(:user_lister) { mock(Bell::UserLister) }
  let(:user_remover) { mock(Bell::UserRemover) }
  let(:user_handler) { described_class.new(output) }

  context "when given an invalid action" do
    let(:invalid_action) { %w[foo] }

    it "shows the usage" do
      output.should_receive(:puts).with(Bell::USAGE)
      user_handler.handle(invalid_action)
    end
  end

  context "when given the 'create' action" do
    context "with valid arguments" do
      let(:valid_create_action) { %w[create foo] }

      it "creates a user creator instance" do
        Bell::UserCreator.should_receive(:new).with(output).and_return(user_creator)
        user_creator.should_receive(:create)
        user_handler.handle(valid_create_action)
      end
    end

    context "with invalid arguments" do
      let(:invalid_create_action) { %w[create foo bar] }

      it "shows the usage" do
        output.should_receive(:puts).with(Bell::USAGE)
        user_handler.handle(invalid_create_action)
      end
    end
  end

  context "when given the 'list' action" do
    context "with valid arguments" do
      let(:valid_list_action) { %w[list] }

      it "creates a user creator instance" do
        Bell::UserLister.should_receive(:new).with(output).and_return(user_lister)
        user_lister.should_receive(:list)
        user_handler.handle(valid_list_action)
      end
    end

    context "with invalid arguments" do
      let(:invalid_list_action) { %w[list foo] }

      it "shows the usage" do
        output.should_receive(:puts).with(Bell::USAGE)
        user_handler.handle(invalid_list_action)
      end
    end
  end

  context "when given the 'remove' action" do
    context "with valid arguments" do
      let(:valid_remove_action) { %w[remove foo] }

      it "creates a user remover instance" do
        Bell::UserRemover.should_receive(:new).with(output).and_return(user_remover)
        user_remover.should_receive(:remove)
        user_handler.handle(valid_remove_action)
      end
    end

    context "with invalid arguments" do
      let(:invalid_remove_action) { %w[remove foo bar] }

      it "shows the usage" do
        output.should_receive(:puts).with(Bell::USAGE)
        user_handler.handle(invalid_remove_action)
      end
    end
  end
end
