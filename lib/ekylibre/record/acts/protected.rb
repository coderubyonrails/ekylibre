module Ekylibre::Record

  class RecordNotUpdateable < ActiveRecord::RecordNotSaved
  end

  class RecordNotDestroyable < ActiveRecord::RecordNotSaved
  end

  module Acts #:nodoc:
    module Protected #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        # Blocks update or destroy if necessary
        def protect(options = {}, &block)
          options[:on] = [:update, :destroy] unless options[:on]
          code = "".c
          for callback in [options[:on]].flatten
            method_name = "protected_on_#{callback}?".to_sym

            code << "before_#{callback} :raise_exception_unless_#{callback}able?\n"

            code << "def raise_exception_unless_#{callback}able?\n"
            code << "  unless self.#{callback}able?\n"
            code << "    raise RecordNot#{callback.to_s.camelcase}able\n"
            code << "  end\n"
            code << "end\n"

            code << "def #{callback}able?\n"
            code << "  !#{method_name}\n"
            code << "end\n"

            if block_given?
              define_method(method_name, &block)
            end
          end
          class_eval code
        end

      end
    end
  end
end
Ekylibre::Record::Base.send(:include, Ekylibre::Record::Acts::Protected)
