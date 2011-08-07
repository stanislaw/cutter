require 'set'

class Object
  def time_now
    Time.now.strftime("%s%L").to_i
  end

  def stamper name, &block
    scope = Stamper[name] || Stamper[:default]
    msg = 'no msg'
    if scope
      message = scope.label.values.first
    end

    puts("~ #{message}")
    puts("~ testing: start")
    scope.time_initial = time_now
    yield scope
    time_passed = time_now - scope.time_initial
    puts("~ testing: end (#{time_passed}ms)")
  end
end

class Stamper
  attr_reader :label
  attr_accessor :time_initial

  def initialize label
    @label = label
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
    message = messages[lbl] || lbl
    time_passed = time_now - time_initial
    printf("~ stamp: %7d ms   #{message}\n", time_passed)
  end

  module ClassMethods
    def scope label, &block
      raise ArgumentError, "Must have hash, was: #{label}" if !label.kind_of? Hash
      raise ArgumentError, "Must have block" if !block
      stamper = Stamper.new(label)
      stampers[label.keys.first] = stamper
      yield stamper
      stamper
    end

    def [] key
      stampers[key]
    end

    protected

    def stampers
      @stampers ||= {}
    end
  end
  extend ClassMethods
end
