require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Bell::Handlers::ReportsHandler do
  let(:params) { mock("params").as_null_object }
  let(:reports_handler) { described_class }

  describe "when given a path to a non-existing file or directory" do
    let(:no_such_file_or_directory_message) do
      Bell::Message.no_such_file_or_directory(params[:path])
    end

    it "shows the 'no such file or directory' message" do
      Embratel::PhoneBill.stub!(:new).and_raise(Errno::ENOENT)
      reports_handler.should_receive(:display).with(no_such_file_or_directory_message)
      reports_handler.full_report(params)
    end
  end

  describe "when given a path to a directory" do
    let(:path_is_a_directory_message) do
      Bell::Message.path_is_a_directory(params[:path])
    end

    it "shows the 'path is a directory' message" do
      Embratel::PhoneBill.stub!(:new).and_raise(Errno::EISDIR)
      reports_handler.should_receive(:display).with(path_is_a_directory_message)
      reports_handler.full_report(params)
    end
  end

  describe "when given a path to a malformed csv file" do
    let(:invalid_phone_bill_file_message) do
      Bell::Message.invalid_phone_bill_file(params[:path])
    end

    it "shows the 'invalid phone bill file' message" do
      Embratel::PhoneBill.stub!(:new).and_raise(FasterCSV::MalformedCSVError)
      reports_handler.should_receive(:display).with(invalid_phone_bill_file_message)
      reports_handler.full_report(params)
    end
  end

  describe "when given a path to an invalid phone bill file" do
    let(:invalid_phone_bill_file_message) do
      Bell::Message.invalid_phone_bill_file(params[:path])
    end

    it "shows the 'invalid phone bill file' message" do
      Embratel::PhoneBill.stub!(:new).and_raise(Embratel::InvalidPhoneBillFileError)
      reports_handler.should_receive(:display).with(invalid_phone_bill_file_message)
      reports_handler.full_report(params)
    end
  end

  describe "when givan a path to a valid phone bill file" do
    let(:report) { mock(Bell::Report, :to_s => mock("string")) }
    let(:phone_bill) { mock(Embratel::PhoneBill) }

    it "shows the report" do
      Embratel::PhoneBill.stub!(:new).and_return(phone_bill)
      Bell::Report.should_receive(:new).with(phone_bill).and_return(report)
      reports_handler.should_receive(:display).with(report.to_s)
      reports_handler.full_report(params)
    end
  end
end
