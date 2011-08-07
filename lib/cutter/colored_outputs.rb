require 'colorize'
class Object
  def log_coloured sp, msg, color = :white
    message = sp + msg
    puts color ? message.send(color) : message
  end
end

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
      @colors ||= {:line => :blue, :time => :light_blue}
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end
end
