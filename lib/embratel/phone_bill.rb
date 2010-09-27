require 'fastercsv'

module Embratel
  class PhoneBill
    def initialize(path)
      begin
        @csv = FasterCSV.read(path, { :skip_blanks => true })
      rescue Errno::ENOENT
        raise
      rescue Errno::EISDIR
        raise
      rescue FasterCSV::MalformedCSVError
        raise
      else
        raise InvalidPhoneBillFileError if invalid_rows?
      end
    end

    def calls
      @calls ||= @csv.inject([]) do |calls, row|
        call = Call.new(row)
        call.valid? ? (calls << call) : calls
      end
    end

    def total
      @total ||= calls.inject(0) { |sum, call| sum += call.cost.to_f }
    end

    private
    def invalid_rows?
      csv = @csv.dup
      3.times  { csv.shift }
      csv.any? { |row| !Call.new(row).valid? }
    end
  end
end
