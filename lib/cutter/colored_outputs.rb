require 'colorize'

class Object
  def __colorize__ obj
    colors = Cutter::ColoredOutputs.colors_config
    color = colors[obj] || :default
    color != :default ? to_s.send(color) : to_s
  end

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
        @colors ||= {
                      # Colors for #stamper
                      :line => :blue,
                      :time => :light_blue,

                      :message_name => :cyan,
                      :message_line => :cyan,
                      :total_line => :yellow,
                      :total_count => :yellow,

                      # Colors for #inspect!
                      #  :called_from => :light_magenta,

                      :class_name => :light_green,
                      :method => :red,
                      :method_name => :yellow,

                      # :source => :white,
                      # :source_path => :white,
                      # :source_number => :white,
                      # :lv => :blue,
                      # :lv_names => :magenta,
                      # :lv_values => :light_red,
                      # :iv => :cyan,
                      :iv_names => :cyan,
                      :iv_values => :light_blue,
                      :self_inspection => :red,
                      :self_inspection_trace => :blue,
                      :caller_methods => :red,
                      :caller_method => :green
                    }
      end
    end

    extend ClassMethods

    def self.included(base)
      base.extend ClassMethods
    end
  end
end
