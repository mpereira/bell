module Bell
  class ReportsHandler
    include Displayable

    def self.create(params = {})
      begin
        phone_bill = Embratel::PhoneBill.new(params[:path])
      rescue Errno::ENOENT
        display Message.no_such_file_or_directory(params[:path])
      rescue Errno::EISDIR
        display Message.path_is_a_directory(params[:path])
      rescue FasterCSV::MalformedCSVError, Embratel::InvalidPhoneBillFileError
        display Message.invalid_phone_bill_file(params[:path])
      else
        display Report.new(phone_bill).to_s
      end
    end
  end
end
