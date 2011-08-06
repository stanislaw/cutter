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
    messages << label
  end

  alias_method :<<, :msg

  def [] key
   # puts "msgs:" << messages.inspect
   found = messages.select do |s|
     s.keys.first == key
   end
   found.first
  end

  def messages
    @messages ||= Set.new
  end

  def stamp lbl = :none
    msg = self[lbl]
    message = msg ? msg.values.first : nil
    time_passed = time_now - time_initial
    message = msg ? "~ testing: #{message}, #{time_passed}ms" : "#{time_passed}ms"
    puts message
  end

  module ClassMethods
    def scope label, &block
      raise ArgumentError, "Must have hash, was: #{label}" if !label.kind_of? Hash
      raise ArgumentError, "Must have block" if !block
      stamper = Stamper.new(label)
      stampers << stamper
      yield stamper
      stamper
    end

    def [] key
      stampers.select{|s| s.label.keys.first == key }.first
    end

    protected

    def stampers
      @stampers ||= Set.new
    end
  end
  extend ClassMethods
end
