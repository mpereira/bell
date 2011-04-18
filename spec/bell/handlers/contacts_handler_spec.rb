require File.expand_path(File.dirname(__FILE__) << '/../../spec_helper')

describe Bell::Handlers::ContactsHandler do
  let(:params) { mock("params").as_null_object }
  let(:formatted_contact_list) { mock("formatted_contact_list") }
  let(:user) do
    mock(Bell::User, :id => 1,
         :null_object => true,
         :contacts => mock("contacts"))
  end
  let(:contact) { mock(Bell::Contact).as_null_object }
  let(:contacts_handler) { described_class }

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
    context "when given a path to a non-existing file or directory" do
      let(:no_such_file_or_directory_message) do
        Bell::Message.no_such_file_or_directory(params[:path])
      end

      it "shows the 'no such file or directory' message" do
        Bell::CSV.stub!(:read).and_raise(Errno::ENOENT)
        contacts_handler.should_receive(:display).with(no_such_file_or_directory_message)
        contacts_handler.import(params)
      end
    end

    context "when given a path to a directory" do
      let(:path_is_a_directory_message) do
        Bell::Message.path_is_a_directory(params[:path])
      end

      it "shows the 'path is a directory' message" do
        Bell::CSV.stub!(:read).and_raise(Errno::EISDIR)
        contacts_handler.should_receive(:display).with(path_is_a_directory_message)
        contacts_handler.import(params)
      end
    end

    context "when given a path to a malformed csv file" do
      let(:invalid_contacts_file_message) do
        Bell::Message.invalid_contacts_file(params[:path])
      end

      it "shows the 'invalid contacts file' message" do
        Bell::CSV.stub!(:read).and_raise(Bell::CSV::MalformedCSVError)
        contacts_handler.should_receive(:display).with(invalid_contacts_file_message)
        contacts_handler.import(params)
      end
    end

    context "when given a csv file with invalid rows" do
      let(:contacts) do
        [first_row, second_row].inject([]) { |contacts, row| contacts << row }
      end

      context "when there's a row with less than two columns" do
        let(:row_with_few_columns_message) { mock("row_with_few_columns_message") }
        let(:first_row) { ["bob", "9876987698"] }
        let(:second_row) { ["kennedy"] }

        it "shows the 'row with few columns' message" do
          Bell::CSV.stub!(:read).and_return(contacts)
          Bell::User.stub!(:find).and_return(user)
          Bell::Message.should_receive(:row_with_few_columns).
            with(second_row, 2).
            and_return(row_with_few_columns_message)
          contacts_handler.should_receive(:display).
            with(row_with_few_columns_message)
          contacts_handler.import(params)
        end
      end

      context "when there's a row with more than two columns" do
        let(:row_with_extra_columns_message) { mock("row_with_extra_columns_message") }
        let(:first_row) { ["1234123412", "john", "kennedy"] }
        let(:second_row) { ["bob", "9876987698"] }

        it "shows the 'row with extra columns' message" do
          Bell::CSV.stub!(:read).and_return(contacts)
          Bell::User.stub!(:find).and_return(user)
          Bell::Message.should_receive(:row_with_extra_columns).
            with(first_row, 1).
            and_return(row_with_extra_columns_message)
          contacts_handler.should_receive(:display).
            with(row_with_extra_columns_message)
          contacts_handler.import(params)
        end
      end
    end

    context "when given a valid csv file" do
      context "when the given user exists" do
        let(:formatted_contact_errors) { mock("formatted_contact_errors") }
        let(:first_contact) do
          Bell::Contact.new(:name => first_row.first,
                            :number => first_row.last,
                            :user_id => user.id)
        end
        let(:second_contact) do
          Bell::Contact.new(:name => second_row.first,
                            :number => second_row.last,
                            :user_id => user.id)
        end
        let(:contacts) do
          [first_row, second_row].inject([]) { |contacts, row| contacts << row }
        end

        context "when there's a row with a short contact number" do
          let(:first_row) { ["john", "1234123412"] }
          let(:second_row) { ["bob", "987698769"] }

          it "shows the contact's errors" do
            Bell::CSV.stub!(:read).and_return(contacts)
            Bell::User.stub!(:find).and_return(user)
            contacts_handler.should_receive(:formatted_contact_errors).
              with(second_contact, :line_number => 2).
              and_return(formatted_contact_errors)
            contacts_handler.should_receive(:display).
              with(formatted_contact_errors)
            contacts_handler.import(params)
          end
        end

        context "when there's a row with a long contact number" do
          let(:first_row) { ["john", "1234123412"] }
          let(:second_row) { ["bob", "98769876989"] }

          it "shows the contact's errors" do
            Bell::CSV.stub!(:read).and_return(contacts)
            Bell::User.stub!(:find).and_return(user)
            contacts_handler.should_receive(:formatted_contact_errors).
              with(second_contact, :line_number => 2).
              and_return(formatted_contact_errors)
            contacts_handler.should_receive(:display).
              with(formatted_contact_errors)
            contacts_handler.import(params)
          end
        end

        context "when the contact object is not valid for some reason" do
          let(:row) { mock("row", :size => 2, :null_object => true) }
          let(:index) { mock("index", :null_object => true) }
          let(:contact_rows) { mock("contact_rows", :null_object => true) }
          let(:invalid_contact) { mock(Bell::Contact, :valid? => false) }

          it "shows the contact's errors" do
            Bell::CSV.stub!(:read).and_return(contact_rows)
            Bell::User.stub!(:find).and_return(user)
            contact_rows.should_receive(:each_with_index).and_yield(row, index)
            Bell::Contact.should_receive(:new).and_return(invalid_contact)
            contacts_handler.should_receive(:formatted_contact_errors).
              with(invalid_contact, :line_number => index).
              and_return(formatted_contact_errors)
            contacts_handler.should_receive(:display).
              with(formatted_contact_errors)
            contacts_handler.import(params)
          end
        end
      end

      context "when the given user doesn't exist" do
        let(:user_does_not_exist_message) { mock("user_does_not_exist_message") }

        it "shows the 'user does not exist message'" do
          Bell::CSV.stub!(:read).and_raise(nil)
          Bell::User.stub!(:find).and_return(nil)
          Bell::Message.should_receive(:user_does_not_exist).
            with(params[:user][:name]).
            and_return(user_does_not_exist_message)
          contacts_handler.should_receive(:display).
            with(user_does_not_exist_message)
          contacts_handler.import(params)
        end
      end
    end
  end
end
