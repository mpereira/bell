module Bell::Handlers
  class ReportsHandler
    include Bell::Displayable

    def self.full_report(params = {})
      begin
        phone_bill = Embratel::PhoneBill.new(params[:path])
      rescue Errno::ENOENT
        display Bell::Message.no_such_file_or_directory(params[:path])
      rescue Errno::EISDIR
        display Bell::Message.path_is_a_directory(params[:path])
      rescue Bell::CSV::MalformedCSVError, Embratel::InvalidPhoneBillFileError
        display Bell::Message.invalid_phone_bill_file(params[:path])
      else
        display Bell::FullReport.new(phone_bill).to_s
      end
    end

    def self.user_report(params = {})
      phone_bill = Embratel::PhoneBill.new(params[:path])
    rescue Errno::ENOENT
      display Bell::Message.no_such_file_or_directory(params[:path])
    rescue Errno::EISDIR
      display Bell::Message.path_is_a_directory(params[:path])
    rescue Bell::CSV::MalformedCSVError, Embratel::InvalidPhoneBillFileError
      display Bell::Message.invalid_phone_bill_file(params[:path])
    else
      if Bell::User.find(:name => params[:user][:name])
        display Bell::UserReport.new(phone_bill, params[:user][:name]).to_s
      else
        display Bell::Message.user_does_not_exist(params[:user][:name])
      end
    end
  end
end
