module Bell
  module Displayable
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def display(text)
        Bell.output.puts text.to_s
      end
    end
  end
end
