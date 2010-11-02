require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Bell::Handlers::ReportsHandler do
  let(:no_such_file_or_directory_message) do
    mock("no_such_file_or_directory_message")
  end

  let(:path_is_a_directory_message) do
    mock("path_is_a_directory_message")
  end

  let(:invalid_phone_bill_file_message) do
    mock("invalid_phone_bill_file_message")
  end

  let(:phone_bill) { mock(Embratel::PhoneBill) }

  context "when requesting a 'full report'" do
    let(:params) { { :path => 'fatura.csv' } }

    context "when given a path to a non-existing file or directory" do
      it "shows the 'no such file or directory' message" do
        Embratel::PhoneBill.stub!(:new).and_raise(Errno::ENOENT)
        Bell::Message.should_receive(:no_such_file_or_directory).
          with(params[:path]).
          and_return(no_such_file_or_directory_message)
        described_class.should_receive(:display).
          with(no_such_file_or_directory_message)
        described_class.full_report(params)
      end
    end

    context "when given a path to a directory" do
      it "shows the 'path is a directory' message" do
        Embratel::PhoneBill.stub!(:new).and_raise(Errno::EISDIR)
        Bell::Message.should_receive(:path_is_a_directory).
          with(params[:path]).
          and_return(path_is_a_directory_message)
        described_class.should_receive(:display).
          with(path_is_a_directory_message)
        described_class.full_report(params)
      end
    end

    context "when given a path to a malformed CSV file" do
      it "shows the 'invalid phone bill file' message" do
        Embratel::PhoneBill.stub!(:new).and_raise(FasterCSV::MalformedCSVError)
        Bell::Message.should_receive(:invalid_phone_bill_file).
          with(params[:path]).
          and_return(invalid_phone_bill_file_message)
        described_class.should_receive(:display).
          with(invalid_phone_bill_file_message)
        described_class.full_report(params)
      end
    end

    context "when given a path to an invalid phone bill file" do
      it "shows the 'invalid phone bill file' message" do
        Embratel::PhoneBill.stub!(:new).and_raise(Embratel::InvalidPhoneBillFileError)
        Bell::Message.should_receive(:invalid_phone_bill_file).
          with(params[:path]).
          and_return(invalid_phone_bill_file_message)
        described_class.should_receive(:display).with(invalid_phone_bill_file_message)
        described_class.full_report(params)
      end
    end

    context "when given a path to a valid phone bill file" do
      let(:report) { mock(Bell::FullReport, :to_s => mock("string")) }

      it "shows the report" do
        Embratel::PhoneBill.stub!(:new).and_return(phone_bill)
        Bell::FullReport.should_receive(:new).with(phone_bill).and_return(report)
        described_class.should_receive(:display).with(report.to_s)
        described_class.full_report(params)
      end
    end
  end

  context "when requesting a 'user report'" do
    let(:params) { { :path => 'fatura.csv', :user => { :name => 'bob' } } }

    context "when given a path to a non-existing file or directory" do
      it "shows the 'no such file or directory' message" do
        Embratel::PhoneBill.stub!(:new).and_raise(Errno::ENOENT)
        Bell::Message.should_receive(:no_such_file_or_directory).
          with(params[:path]).
          and_return(no_such_file_or_directory_message)
        described_class.should_receive(:display).
          with(no_such_file_or_directory_message)
        described_class.user_report(params)
      end
    end

    context "when given a path to a directory" do
      it "shows the 'path is a directory' message" do
        Embratel::PhoneBill.stub!(:new).and_raise(Errno::EISDIR)
        Bell::Message.should_receive(:path_is_a_directory).
          with(params[:path]).
          and_return(path_is_a_directory_message)
        described_class.should_receive(:display).
          with(path_is_a_directory_message)
        described_class.user_report(params)
      end
    end

    context "when given a path to a malformed CSV file" do
      it "shows the 'invalid phone bill file' message" do
        Embratel::PhoneBill.stub!(:new).and_raise(FasterCSV::MalformedCSVError)
        Bell::Message.should_receive(:invalid_phone_bill_file).
          with(params[:path]).
          and_return(invalid_phone_bill_file_message)
        described_class.should_receive(:display).
          with(invalid_phone_bill_file_message)
        described_class.user_report(params)
      end
    end

    context "when given a path to an invalid phone bill file" do
      it "shows the 'invalid phone bill file' message" do
        Embratel::PhoneBill.stub!(:new).and_raise(Embratel::InvalidPhoneBillFileError)
        Bell::Message.should_receive(:invalid_phone_bill_file).
          with(params[:path]).
          and_return(invalid_phone_bill_file_message)
        described_class.should_receive(:display).with(invalid_phone_bill_file_message)
        described_class.user_report(params)
      end
    end

    context "when given a path to a valid phone bill file" do
      context "when given user exists" do
        let(:user) { mock(Bell::User) }
        let(:user_report) { mock(Bell::UserReport, :to_s => mock("string")) }

        it "shows the report" do
          Embratel::PhoneBill.stub!(:new).and_return(phone_bill)
          Bell::User.stub!(:find).
            with(:name => params[:user][:name]).
            and_return(user)
          Bell::UserReport.should_receive(:new).
            with(phone_bill, params[:user][:name]).
            and_return(user_report)
          described_class.should_receive(:display).with(user_report.to_s)
          described_class.user_report(params)
        end
      end

      context "when given user doesn't exist" do
        let(:user_does_not_exist_message) { mock("user_does_not_exist_message") }

        it "shows the 'user does not exist' message" do
          Embratel::PhoneBill.stub!(:new).and_return(phone_bill)
          Bell::User.stub!(:find).
            with(:name => params[:user][:name]).
            and_return(nil)
          Bell::Message.should_receive(:user_does_not_exist).
            with(params[:user][:name]).
            and_return(user_does_not_exist_message)
          described_class.should_receive(:display).
            with(user_does_not_exist_message)
          described_class.user_report(params)
        end
      end
    end
  end
end
