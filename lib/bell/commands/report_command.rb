module Bell::Commands
  class ReportCommand < Command
    USER_NAME_FLAGS = %w[-u --user]
    CONTACT_NUMBER_FLAGS = %w[-n --number]

    USAGE = <<-USAGE.gsub(/^      /, '')
      uso: bell report /path/fatura.csv [<argumentos>]

        Argumentos:
        -u|--user <usuário>    Mostra relatório para o dado usuário
        -n|--number <número>   Mostra relatório para o dado número de telefone
    USAGE

    FULL_REPORT_USAGE = <<-FULL_REPORT_USAGE.gsub(/^      /, '')
      uso: bell report /path/fatura.csv
    FULL_REPORT_USAGE

    def initialize(args = [])
      super(args)
      @handler = 'reports_handler'
    end

    def parse
      if full_report?
        @action = 'full_report'
        if @args[0]
          @params = { :path => @args[0] }
        else
          raise ArgumentError, FULL_REPORT_USAGE
        end
      else
        raise ArgumentError, USAGE
      end

      self
    end

    private

    def user_name_given?
      !(@args & USER_NAME_FLAGS).empty?
    end

    def contact_number_given?
      !(@args & USER_NAME_FLAGS).empty?
    end

    def full_report?
      !user_name_given? && !contact_number_given?
    end
  end
end
