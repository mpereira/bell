require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Bell::ReportCreator do
  let(:output) { mock("output").as_null_object }
  let(:report) { mock(Bell::Report) }
  let(:report_creator) { described_class.new(output) }

  context "when the path points to a file that doesn't exist" do
    let(:non_existing_file_path) { File.join(FIXTURES_PATH, 'non_existing_file.txt') }

    it "shows the 'file does not exist' message" do
      output.should_receive(:puts).
        with(Bell::OutputFormatter.no_such_file_or_directory(non_existing_file_path))
      report_creator.create(non_existing_file_path)
    end
  end

  context "when the path points to a directory" do
    let(:directory_path) { File.join(FIXTURES_PATH) }

    it "shows the 'path is a directory' message" do
      output.should_receive(:puts).
        with(Bell::OutputFormatter.path_is_a_directory(directory_path))
      report_creator.create(directory_path)
    end
  end

  context "when the path points to a non phone bill file" do
    let(:non_phone_bill_path) { File.join(FIXTURES_PATH, 'text_file.txt') }

    it "shows the 'invalid bill file' message" do
      output.should_receive(:puts).
        with(Bell::OutputFormatter.invalid_phone_bill_file(non_phone_bill_path))
      report_creator.create(non_phone_bill_path)
    end
  end

  context "when the path points to an invalid phone bill file" do
    let(:invalid_phone_bill_file_path) { File.join(FIXTURES_PATH, 'invalid_phone_bill_file.csv') }

    it "shows the 'invalid bill file' message" do
      output.should_receive(:puts).
        with(Bell::OutputFormatter.invalid_phone_bill_file(invalid_phone_bill_file_path))
      report_creator.create(invalid_phone_bill_file_path)
    end
  end

  context "when the path points to a valid phone bill file" do
    let(:valid_phone_bill_file_path) { File.join(FIXTURES_PATH, 'valid_phone_bill_file.csv') }

    it "shows the report" do
      Bell::Report.should_receive(:new).and_return(report)
      report.should_receive(:to_s)
      report_creator.create(valid_phone_bill_file_path)
    end
  end
end
