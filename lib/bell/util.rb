module Bell
  module Util
    module String
      def self.included(base)
        base.send(:extend, Util::String)
      end

      def camelize(lower_case_and_underscored_word, first_letter_in_uppercase = true)
        if first_letter_in_uppercase
          lower_case_and_underscored_word.
             to_s.
             gsub(/\/(.?)/) { "::#{$1.upcase}" }.
             gsub(/(?:^|_)(.)/) { $1.upcase }
        else
          lower_case_and_underscored_word.
            to_s[0].
            chr.
            downcase + camelize(lower_case_and_underscored_word)[1..-1]
        end
      end

      def sanitize(string)
        string.unpack("C*").pack("U*")
      end

      def multibyte_length(string)
        RUBY_VERSION < '1.9' ? string.jsize : string.size
      end
    end
  end
end
