require 'set'
require 'active_support/core_ext/string/inflections.rb'
require 'colorize'

class Object
  def time_now
    Time.now.strftime("%s%L").to_i
  end

  def stamper name = nil, &block
    def line sp
      log_coloured sp, "------------------------------", color(:line)
    end

    def log_time sp, msg
      log_coloured sp, msg, color(:time)
    end

    def color type
      Stamper.colors_config[type] if Stamper.colors?
    end

    return if Stamper.off?
    scope = Stamper[name] || Stamper[:default]
    scope.indent = Stamper.last ? Stamper.last.indent + 1 : 0
    Stamper.push scope

    msg = 'no msg'
    if scope
      message = scope.label.values.first
    end
    spaces = "  " * scope.indent
    line spaces
    log_coloured spaces, "~ START " << "#{message}"
    scope.time_initial = time_now
    yield scope
    scope.indent -= 1 if scope.indent > 0
    Stamper.pop
    time_passed = time_now - scope.time_initial
    log_coloured spaces, "~ END " << "#{message}"
    log_time spaces, "[#{time_passed}ms]"
    line spaces
  end
end

class Stamper
  attr_reader   :label
  attr_accessor :time_initial
  attr_writer   :indent

  include ColoredOutputs

  def initialize label
    @label = label
    @indent = 0
  end

  def self.turn state = :on
    @state = state
  end

  def self.on?
    @state ||= :on
    @state == :on
  end

  def self.off?
    !on?
  end

  def indent
    @indent ||= 0
  end

  def nindent
    @indent +1
  end

  def msg label
    messages[label.keys.first] = label.values.first
  end

  alias_method :<<, :msg

  def messages
    @messages ||= {}
  end

  def [] key
    messages[key]
  end

  def stamp lbl = nil
    return if Stamper.off?
    message = messages[lbl] || lbl.to_s.humanize
    time_passed = time_now - time_initial
    print "  " * nindent
    printf("~ stamp: %7d ms   #{message}\n", time_passed)
  end

  module ClassMethods

    def scope label, &block
      raise ArgumentError, "Must have hash, was: #{label}" if !label.kind_of? Hash
      raise ArgumentError, "Must have block" if !block
      stamper = Stamper.new(label)
      stampers[label.keys.first] = stamper
      yield stamper
      stamper_stack.pop
      stamper
    end

    def last
      stamper_stack.last
    end

    def push stamper
      stamper_stack.push stamper
    end

    def pop
      stamper_stack.pop
    end

    def [] key
      stampers[key]
    end

    protected

    def stamper_stack
      @stamper_stack ||= []
    end

    def stampers
      @stampers ||= {}
    end
  end
  extend ClassMethods
end

Stamper.scope :default => nil do |default|
end
