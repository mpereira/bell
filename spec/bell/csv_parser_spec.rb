#require File.expand_path(File.dirname(__FILE__) << '/../spec_helper')

#describe Bell::CSVParser do
  #describe ".parse_contacts_file" do
    #let(:path) { mock('path') }
    #let(:contact_rows) do
      #[first_row, second_row].inject([]) { |contact_rows, row| contact_rows << row }
    #end

    #context "when given a path to a non-existing file or directory" do
      #let(:no_such_file_or_directory_message) do
        #Bell::Message.no_such_file_or_directory(path)
      #end

      #it "shows the 'no such file or directory' message" do
        #Bell::CSV.stub!(:read).and_raise(Errno::ENOENT)
        #described_class.should_receive(:display).with(no_such_file_or_directory_message)
        #described_class.parse_contacts_file(path)
      #end
    #end

    #context "when given a path to a directory" do
      #let(:path_is_a_directory_message) do
        #Bell::Message.path_is_a_directory(path)
      #end

      #it "shows the 'path is a directory' message" do
        #Bell::CSV.stub!(:read).and_raise(Errno::EISDIR)
        #described_class.should_receive(:display).with(path_is_a_directory_message)
        #described_class.parse_contacts_file(path)
      #end
    #end

    #context "when given a path to a malformed csv file" do
      #let(:invalid_contacts_file_message) do
        #Bell::Message.invalid_contacts_file(path)
      #end

      #it "shows the 'invalid contacts file' message" do
        #Bell::CSV.stub!(:read).and_raise(Bell::CSV::MalformedCSVError)
        #described_class.should_receive(:display).with(invalid_contacts_file_message)
        #described_class.parse_contacts_file(path)
      #end
    #end

    #context "when given a csv file with invalid rows" do
      #context "when there's a row with less than two columns" do
        #let(:row_with_few_columns_message) { mock("row_with_few_columns_message") }
        #let(:first_row) { ["bob", "9876987698"] }
        #let(:second_row) { ["kennedy"] }

        #it "shows the 'row with few columns' message" do
          #Bell::CSV.stub!(:read).and_return(contact_rows)
          #Bell::Message.should_receive(:row_with_few_columns).
            #with(second_row, 2).
            #and_return(row_with_few_columns_message)
          #described_class.should_receive(:display).
            #with(row_with_few_columns_message)
          #described_class.parse_contacts_file(path)
        #end
      #end

      #context "when there's a row with more than two columns" do
        #let(:row_with_extra_columns_message) { mock("row_with_extra_columns_message") }
        #let(:first_row) { ["1234123412", "john", "kennedy"] }
        #let(:second_row) { ["bob", "9876987698"] }

        #it "shows the 'row with extra columns' message" do
          #Bell::CSV.stub!(:read).and_return(contact_rows)
          #Bell::Message.should_receive(:row_with_extra_columns).
            #with(first_row, 1).
            #and_return(row_with_extra_columns_message)
          #described_class.should_receive(:display).
            #with(row_with_extra_columns_message)
          #described_class.parse_contacts_file(path)
        #end
      #end
    #end

    #context "when given a valid csv file" do
      #let(:formatted_contact_errors) { mock("formatted_contact_errors") }
      #let(:user) { mock(Bell::User, :id => 1) }
      #let(:first_contact) do
        #Bell::Contact.new(:name => first_row.first,
                          #:number => first_row.last,
                          #:user_id => user.id)
      #end
      #let(:second_contact) do
        #Bell::Contact.new(:name => second_row.first,
                          #:number => second_row.last,
                          #:user_id => user.id)
      #end

      #context "when there's a row with a short contact number" do
        #let(:first_row) { ["john", "1234123412"] }
        #let(:second_row) { ["bob", "987698769"] }

        #it "shows the contact's errors" do
          #Bell::CSV.stub!(:read).and_return(contact_rows)
          #described_class.should_receive(:formatted_contact_errors).
            #with(second_contact, :line_number => 2).
            #and_return(formatted_contact_errors)
          #described_class.should_receive(:display).
            #with(formatted_contact_errors)
          #described_class.parse_contacts_file(path)
        #end
      #end

      ##context "when there's a row with a long contact number" do
        ##let(:first_row) { ["john", "1234123412"] }
        ##let(:second_row) { ["bob", "98769876989"] }

        ##it "shows the contact's errors" do
          ##Bell::CSV.stub!(:read).and_return(contact_rows)
          ##Bell::User.stub!(:find).and_return(user)
          ##described_class.should_receive(:formatted_contact_errors).
            ##with(second_contact, :line_number => 2).
            ##and_return(formatted_contact_errors)
          ##described_class.should_receive(:display).
            ##with(formatted_contact_errors)
          ##described_class.parse_contacts_file(path)
        ##end
      ##end

      ##context "when the contact object is not valid for some reason" do
        ##let(:row) { mock("row", :size => 2, :null_object => true) }
        ##let(:index) { mock("index", :null_object => true) }
        ##let(:contact_rows) { mock("contact_rows", :null_object => true) }
        ##let(:invalid_contact) { mock(Bell::Contact, :valid? => false) }

        ##it "shows the contact's errors" do
          ##Bell::CSV.stub!(:read).and_return(contact_rows)
          ##Bell::User.stub!(:find).and_return(user)
          ##contact_rows.should_receive(:each_with_index).and_yield(row, index)
          ##Bell::Contact.should_receive(:new).and_return(invalid_contact)
          ##described_class.should_receive(:formatted_contact_errors).
            ##with(invalid_contact, :line_number => index).
            ##and_return(formatted_contact_errors)
          ##described_class.should_receive(:display).
            ##with(formatted_contact_errors)
          ##described_class.parse_contacts_file(path)
        ##end
      ##end
    #end
  #end
#end
