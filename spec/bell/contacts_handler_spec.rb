require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Bell::ContactsHandler do
  let(:params) { mock("params").as_null_object }
  let(:formatted_contact_list) { mock("formatted_contact_list") }
  let(:user) { mock(Bell::User).as_null_object }
  let(:contact) { mock(Bell::Contact).as_null_object }
  let(:contacts_handler) { described_class }

  describe ".create" do
    context "when the given user name does not match up with a user" do
      let(:user_does_not_exist_message) do
        Bell::Message.user_does_not_exist(params[:user][:name])
      end

      it "shows the 'user does not exist' message" do
        Bell::User.stub!(:find).and_return(nil)
        contacts_handler.should_receive(:display).with(user_does_not_exist_message)
        contacts_handler.create(params)
      end
    end

    context "when the given user name matches up with a user" do
      context "when the contact to be created is invalid" do
        it "shows its error messages" do
          Bell::User.stub!(:find).and_return(user)
          Bell::Contact.stub!(:new).and_return(contact)
          contact.stub!(:valid?).and_return(false)
          contacts_handler.should_receive(:display).
            with(contacts_handler.formatted_contact_errors(contact))
          contacts_handler.create(params)
        end
      end

      context "when the contact to be created is valid" do
        let(:contact_created_message) do
          Bell::Message.contact_created(contact)
        end

        before do
          Bell::User.stub!(:find).and_return(user)
          Bell::Contact.stub!(:new).and_return(contact)
          contact.stub!(:valid?).and_return(true)
        end

        it "creates the contact" do
          contact.should_receive(:save)
          contacts_handler.create(params)
        end

        it "shows the 'contact created' message" do
          contacts_handler.should_receive(:display).with(contact_created_message)
          contacts_handler.create(params)
        end
      end
    end
  end

  describe ".list" do
    context "called without extra arguments" do
      context "there are no contacts created" do
        let(:no_contacts_created_message) do
          Bell::Message.no_contacts_created
        end

        it "shows the 'no contacts created' message" do
          params.stub!(:empty?).and_return(true)
          Bell::Contact.stub!(:empty?).and_return(true)
          contacts_handler.should_receive(:display).with(no_contacts_created_message)
          contacts_handler.list
        end
      end

      context "there are contacts created" do
        it "shows a list with all contacts" do
          params.stub!(:empty?).and_return(true)
          Bell::Contact.stub!(:empty?).and_return(false)
          contacts_handler.should_receive(:formatted_contact_list).
            and_return(formatted_contact_list)
          contacts_handler.should_receive(:display).with(formatted_contact_list)
          contacts_handler.list
        end
      end
    end

    context "called with a user name" do
      context "when a user with the given doesn't exist" do
        let(:user_does_not_exist_message) do
          Bell::Message.user_does_not_exist(params[:user][:name])
        end

        it "shows the 'user does not exist' message" do
          params.stub!(:empty?).and_return(false)
          Bell::User.stub!(:find).and_return(false)
          contacts_handler.should_receive(:display).with(user_does_not_exist_message)
          contacts_handler.list(params)
        end
      end

      context "when a user with the given exists" do
        before do
          params.stub!(:empty?).and_return(false)
          Bell::User.stub!(:find).and_return(user)
        end

        context "when doesn't have contacts" do
          let(:contact_list_empty_message) do
            Bell::Message.contact_list_empty(user.name)
          end

          it "shows the 'contact list empty' message" do
            user.stub_chain(:contacts, :empty?).and_return(true)
            contacts_handler.should_receive(:display).with(contact_list_empty_message)
            contacts_handler.list(params)
          end
        end

        context "when it has contacts" do
          it "shows a list with all the users' contacts" do
            user.stub_chain(:contacts, :empty?).and_return(false)
            contacts_handler.should_receive(:formatted_contact_list).
              and_return(formatted_contact_list)
            contacts_handler.should_receive(:display).with(formatted_contact_list)
            contacts_handler.list(params)
          end
        end
      end
    end
  end

  describe ".remove" do
    context "when there is no contact with the given name" do
      let(:contact_does_not_exist_message) do
        Bell::Message.contact_does_not_exist(params[:contact][:name])
      end

      it "shows the 'contact does not exist' message" do
        Bell::Contact.stub!(:find).and_return(nil)
        contacts_handler.should_receive(:display).with(contact_does_not_exist_message)
        contacts_handler.remove(params)
      end
    end

    context "when there is a contact with the given name" do
      let(:contact_removed_message) do
        Bell::Message.contact_removed(params[:contact][:name])
      end

      it "removes the contact" do
        Bell::Contact.stub!(:find).and_return(contact)
        contact.should_receive(:destroy)
        contacts_handler.remove(params)
      end

      it "shows the 'contact removec' message" do
        Bell::Contact.stub!(:find).and_return(contact)
        contacts_handler.should_receive(:display).with(contact_removed_message)
        contacts_handler.remove(params)
      end
    end
  end
end
