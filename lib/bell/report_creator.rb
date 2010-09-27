module Bell
  class ReportCreator
    def initialize(output)
      @output = output
    end

    def create(path)
      begin
        phone_bill = Embratel::PhoneBill.new(path)
      rescue Errno::ENOENT
        @output.puts OutputFormatter.no_such_file_or_directory(path)
      rescue Errno::EISDIR
        @output.puts OutputFormatter.path_is_a_directory(path)
      rescue FasterCSV::MalformedCSVError, Embratel::InvalidPhoneBillFileError
        @output.puts OutputFormatter.invalid_phone_bill_file(path)
      else
        @output.puts Report.new(phone_bill).to_s
      end
    end
  end
end
