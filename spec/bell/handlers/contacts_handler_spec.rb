require File.expand_path(File.dirname(__FILE__) << '/../../spec_helper')

describe Bell::Handlers::ContactsHandler do
  let(:params) { mock("params").as_null_object }
  let(:formatted_contact_list) { mock("formatted_contact_list") }
  let(:user) do
    mock(Bell::User, :id => 1,
         :null_object => true,
         :contacts => mock("contacts"))
  end
  let(:contact) { mock(Bell::UserContact).as_null_object }
  let(:contacts_handler) { described_class }
  let(:no_contacts_created_message) { Bell::Message.no_contacts_created }

  describe ".list" do
    context "called without extra arguments" do
      context "there are no contacts created" do

        it "shows the 'no contacts created' message" do
          params.stub!(:empty?).and_return(true)
          Bell::UserContact.stub!(:empty?).and_return(true)
          contacts_handler.should_receive(:display).with(no_contacts_created_message)
          contacts_handler.list
        end
      end

      context "there are contacts created" do
        it "shows a list with all contacts" do
          params.stub!(:empty?).and_return(true)
          Bell::UserContact.stub!(:empty?).and_return(false)
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

      context "when the given user exists" do
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

          context "when asked for the CSV format" do
            let(:contacts) { mock("contacts", :empty? => false) }
            let(:user) { mock(Bell::User, :name => 'bob', :contacts => contacts) }
            let(:params) { { :user => { :name => user.name }, :csv => true } }

            it "shows a list with all the users' contacts" do
              contacts_handler.should_receive(:formatted_contact_list).
                with(user.contacts, :user_contacts => true, :csv => true).
                and_return(formatted_contact_list)
              contacts_handler.should_receive(:display).
                with(formatted_contact_list)
              contacts_handler.list(params)
            end
          end
        end
      end
    end
  end

  describe ".import" do
    context "when requesting a user contact import" do
      let(:params) { { :user => { :name => 'foo' } } }

      context "when the given user exists" do
        let(:contacts) { [mock(Bell::User), mock(Bell::User) ]}

        context "when the CSVParser returns contacts" do
          it "saves them" do
            Bell::User.stub!(:find).and_return(user)
            Bell::CSVParser.stub!(:parse_contacts).and_return(contacts)
            contacts.each { |contact| contact.should_receive(:save) }
            described_class.import(params)
          end
        end

        context "when CSVParser raises InvalidContacts" do
          it "shows the 'no contacts created' message" do
            Bell::User.stub!(:find).and_return(user)
            Bell::CSVParser.stub!(:parse_contacts).and_raise(Bell::InvalidContacts)
            described_class.should_receive(:display).with(no_contacts_created_message)
            described_class.import(params)
          end
        end
      end

      context "when the given user doesn't exist" do
        let(:user_does_not_exist_message) { mock('user_does_not_exist_message') }

        it "shows the 'user does not exist' message" do
          Bell::User.stub!(:find).and_return(nil)
          Bell::Message.
            should_receive(:user_does_not_exist).
            and_return(user_does_not_exist_message)
          described_class.import(params)
        end
      end
    end

    context "when requesting a public contact import" do
      let(:params) { { :path => '/path/to/public_contacts.csv',
                       :public => true } }
      let(:contacts) { [mock(Bell::User), mock(Bell::User) ]}

      context "when the CSVParser returns contacts" do
        it "saves them" do
          Bell::CSVParser.stub!(:parse_contacts).and_return(contacts)
          contacts.each { |contact| contact.should_receive(:save) }
          described_class.import(params)
        end
      end

      context "when CSVParser returns raises InvalidContacts" do
        it "shows the 'no contacts created' message" do
          Bell::CSVParser.stub!(:parse_contacts).and_raise(Bell::InvalidContacts)
          described_class.should_receive(:display).with(no_contacts_created_message)
          described_class.import(params)
        end
      end
    end
  end
end
