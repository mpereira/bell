# encoding: utf-8

module Bell::Commands
  class ReportCommand < Command
    USAGE = <<-USAGE.gsub(/^      /, '')
      uso: bell report /path/fatura.csv [<argumentos>]

        Argumentos:
        -u|--user <usuário>    Mostra relatório para o dado usuário
        -n|--number <número>   Mostra relatório para o dado número de telefone
    USAGE

    FULL_REPORT_USAGE = <<-FULL_REPORT_USAGE.gsub(/^      /, '')
      uso: bell report /path/fatura.csv
    FULL_REPORT_USAGE

    USER_REPORT_USAGE = <<-USER_REPORT_USAGE.gsub(/^      /, '')
      uso: bell report /path/fatura.csv -u <usuário>
    USER_REPORT_USAGE

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
      elsif user_report?
        @action = 'user_report'
        if valid_args_for_user_report?
          @params = user_report_params
        else
          raise ArgumentError, USER_REPORT_USAGE
        end
      else
        raise ArgumentError, USAGE
      end

      self
    end

    private

    def full_report?
      !user_name_given? && !contact_number_given?
    end

    def user_report?
      user_name_given?
    end

    def valid_args_for_user_report?
      @args.size > 2
    end

    def user_report_params
      user_flag = (@args & USER_NAME_FLAGS).first
      user_name = @args[@args.index(user_flag) + 1]

      { :path => @args[0], :user => { :name => user_name } }
    end
  end
end
