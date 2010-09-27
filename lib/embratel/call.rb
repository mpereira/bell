module Embratel
  class Call
    NUMBER_CALLED_REGEXP = /^\d{10}$/
    COST_REGEXP = /^\d*(\.\d+)?$/
    FIELDS = %w[
                id
                caller
                description
                date
                number_called
                caller_local
                called_local
                start_time
                end_time
                imp
                country
                quantity
                unit
                cost
               ]

    FIELDS.each { |field| attr_accessor field.to_sym }

    def initialize(csv_row)
      @csv_row_size = csv_row.size

      FIELDS.each_with_index do |field, index|
        instance_variable_set("@#{field}".to_sym, csv_row[index].to_s.strip)
      end
    end

    def valid?
      @csv_row_size == 14 &&
      number_called =~ NUMBER_CALLED_REGEXP &&
      cost =~ COST_REGEXP
    end
  end
end
