module Bell
  module Displayable
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def display(text)
        puts sanitize_output(text)
      end

      private
      def sanitize_output(text)
        text.to_s.gsub(/^\s{2,}/, '')
      end
    end
  end
end
