require File.expand_path('../../spec_helper', __FILE__)

describe Bell::CSVParser do
  describe ".parse_contacts" do
    let(:options) { { :path => '/path/to/contacts.csv',
                      :user => { :name => 'foo' } } }
    let(:described_module) { Bell::CSVParser }

    context "when given a path to a non-existing file or directory" do
      let(:no_such_file_or_directory_message) do
        Bell::Message.no_such_file_or_directory(options[:path])
      end

      it "shows the 'no such file or directory' message" do
        Bell::CSV.stub!(:read).and_raise(Errno::ENOENT)
        described_module.
          should_receive(:display).
          with(no_such_file_or_directory_message)
        described_module.parse_contacts(options)
      end
    end

    context "when given a path to a directory" do
      let(:path_is_a_directory_message) do
        Bell::Message.path_is_a_directory(options[:path])
      end

      it "shows the 'path is a directory' message" do
        Bell::CSV.stub!(:read).and_raise(Errno::EISDIR)
        described_module.
          should_receive(:display).
          with(path_is_a_directory_message)
        described_module.parse_contacts(options)
      end
    end

    context "when given a path to a malformed csv file" do
      let(:invalid_contacts_file_message) do
        Bell::Message.invalid_contacts_file(options[:path])
      end

      it "shows the 'invalid contacts file' message" do
        Bell::CSV.stub!(:read).and_raise(Bell::CSV::MalformedCSVError)
        described_module.
          should_receive(:display).
          with(invalid_contacts_file_message)
        described_module.parse_contacts(options)
      end
    end

    context "when given a csv file with invalid rows" do
      let(:user) { mock(Bell::User, :null_object => true) }

      before do
        described_module.stub!(:raise).with(Bell::InvalidContacts)
      end

      context "when there's a row with less than two columns" do
        let(:first_row) { ['bob', '9876987698'] }
        let(:second_row) { ['kennedy'] }
        let(:row_with_few_columns_message) do
          Bell::Message.row_with_few_columns(second_row, 2)
        end

        it "shows the 'row with few columns' message" do
          Bell::CSV.stub!(:read).and_return([first_row, second_row])
          Bell::User.stub!(:find).and_return(user)
          described_module.
            should_receive(:display).
            with(row_with_few_columns_message)
          described_module.parse_contacts(options)
        end
      end

      context "when there's a row with more than two columns" do
        let(:first_row) { ["1234123412", "john", "kennedy"] }
        let(:second_row) { ["bob", "9876987698"] }
        let(:row_with_extra_columns_message) do
          Bell::Message.row_with_extra_columns(first_row, 1)
        end

        it "shows the 'row with extra columns' message" do
          Bell::CSV.stub!(:read).and_return([first_row, second_row])
          Bell::User.stub!(:find).and_return(user)
          described_module.
            should_receive(:display).
            with(row_with_extra_columns_message)
          described_module.parse_contacts(options)
        end
      end
    end

    context "when given a valid csv file" do
      let(:user) { mock(Bell::User, :null_object => true) }

      before do
        described_module.stub!(:raise).with(Bell::InvalidContacts)
      end

      context "when there's a row with a short contact number" do
        let(:first_row) { ["john", "1234123412"] }
        let(:second_row) { ["bob", "987698769"] }
        let(:contact) { Bell::UserContact.new(:name => second_row.first,
                                          :number => second_row.last,
                                          :user_id => user.id) }
        let(:formatted_contact_errors_message) do
          Bell::Message.formatted_contact_errors(contact, :line_number => 2)
        end

        it "shows the contact's errors" do
          Bell::CSV.stub!(:read).and_return([first_row, second_row])
          Bell::User.stub!(:find).and_return(user)
          contact.valid?
          described_module.
            should_receive(:display).
            with(formatted_contact_errors_message)
          described_module.parse_contacts(options)
        end
      end

      context "when there's a row with a long contact number" do
        let(:first_row) { ["bob", "98769876989"] }
        let(:second_row) { ["john", "1234123412"] }
        let(:contact) { Bell::UserContact.new(:name => first_row.first,
                                          :number => first_row.last,
                                          :user_id => user.id) }
        let(:formatted_contact_errors_message) do
          Bell::Message.formatted_contact_errors(contact, :line_number => 1)
        end

        it "shows the contact's errors" do
          Bell::CSV.stub!(:read).and_return([first_row, second_row])
          Bell::User.stub!(:find).and_return(user)
          contact.valid?
          described_module.
            should_receive(:display).
            with(formatted_contact_errors_message)
          described_module.parse_contacts(options)
        end
      end

      context "with empty rows" do
        it "returns nil" do
          Bell::CSV.stub!(:read).and_return([])
          described_module.parse_contacts(options).should be_nil
        end
      end

      context "with valid rows" do
        let(:first_row) { ["john", "1234123412"] }
        let(:second_row) { ["bob", "9876987698"] }
        let(:first_contact) { Bell::UserContact.new(:name => first_row.first,
                                                :number => first_row.last,
                                                :user_id => user.id) }
        let(:second_contact) { Bell::UserContact.new(:name => second_row.first,
                                                 :number => second_row.last,
                                                 :user_id => user.id) }
        it "returns an array with the contact instances" do
          Bell::CSV.stub!(:read).and_return([first_row, second_row])
          Bell::User.stub!(:find).and_return(user)
          described_module.parse_contacts(options).
            should == [first_contact, second_contact]
        end
      end
    end
  end
end
