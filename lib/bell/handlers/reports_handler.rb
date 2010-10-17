module Bell::Handlers
  class ReportsHandler
    include Bell::Displayable

    def self.create(params = {})
      begin
        phone_bill = Embratel::PhoneBill.new(params[:path])
      rescue Errno::ENOENT
        display Bell::Message.no_such_file_or_directory(params[:path])
      rescue Errno::EISDIR
        display Bell::Message.path_is_a_directory(params[:path])
      rescue FasterCSV::MalformedCSVError, Embratel::InvalidPhoneBillFileError
        display Bell::Message.invalid_phone_bill_file(params[:path])
      else
        display Bell::Report.new(phone_bill).to_s
      end
    end
  end
end
