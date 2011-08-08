require 'colorize'
class Object
  
  def line sp = ""
    log_coloured sp, "------------------------------", color(:line)
  end

  def log_coloured sp, msg, color = :default
    message = sp + msg
    message = color != :default ? message.send(color) : message
    puts message
  end
end

module Cutter
  module ColoredOutputs
    module ClassMethods
      def turn_colors state = :on
        @colors_state = state
      end

      def colors?
        @colors_state ||= :on
        @colors_state == :on
      end

      def colors &block
        yield colors_config
      end

      def colors_config
        @colors ||= {:line => :blue, 
                     :time => :light_blue,

                     # Colors for #inspect!
                     #:called_from => :light_magenta,
                     #:class_name => :red,
                     #:method => :blue,
                     #:method_name => :green,
                     #:lv => :blue,
                     #:lv_names => :magenta,
                     #:lv_values => :light_red,
                     #:iv => :cyan,
                     #:iv_names => :light_cyan,
                     #:iv_values => :light_blue,
                     #:self_inspection => :red,
                     #:self_inspection_trace => :blue,
                     #:caller_methods => :light_cyan,
                     #:caller_method => :green
                    }
      end
    end

    extend ClassMethods

    def self.included(base)
      base.extend ClassMethods
    end
  end
end
