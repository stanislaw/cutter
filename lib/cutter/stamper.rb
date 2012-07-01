class Time
  def ms_since time
    ((Time.now - time) * 1000).to_i
  end
end

class Object
  def stamper *args, &block
    return if stamper_class.off?

    options = args.extract_options!

    name = args.first

    capture = options.delete :capture


    scope = stamper_class[name] || stamper_class[:default]
    scope.indent = stamper_class.last ? stamper_class.last.indent + 1 : 0
    stamper_class.push scope

    msg = 'no msg'
    if scope
      message = scope.label.values.first
    end

    print "\n"

    spaces = "    " * scope.indent

    log_coloured spaces, "#{message}", __color__(:message_name)
    log_coloured spaces, "#{'-'*message.length}", __color__(:message_line)

    scope.time_initial = Time.now

    (class << self; self end).send :define_method, :stamp do |*args|
      scope.stamp args.first
    end

    (class << self; self end).send :define_method, :stamp! do |*args|
      scope.stamp args.first
    end

    capture ? capture_stdout { yield scope } : yield(scope)

    (class << self; self end).send :remove_method, :stamp if respond_to? :stamp
    (class << self; self end).send :remove_method, :stamp! if respond_to? :stamp!

    scope.indent -= 1 if scope.indent > 0
    stamper_class.pop

    time_passed = Time.now.ms_since scope.time_initial

    tps = "#{time_passed}ms"
    offset = message.length - tps.length
    offset = 0 if offset < 0
    log_coloured spaces, "#{'-'*message.length}", __color__(:total_line)
    log_coloured spaces + "#{' ' * (offset)}", tps, __color__(:total_count)
    print "\n"

    tps
  end

  private

  def __color__ type
    stamper_class.colors_config[type] if stamper_class.colors?
  end

  def stamper_class
    Cutter::Stamper
  end
end

module Cutter
  class Stamper
    attr_reader   :label
    attr_accessor :time_initial
    attr_writer   :indent

    include Cutter::ColoredOutputs

    def initialize label
      @label = label
      @indent = 0
    end

    def self.turn state = :on
      @@state = state
    end

    def self.quiet!
      self.turn :off
    end

    def self.loud!
      self.turn :on
    end

    def self.on?
      @@state ||= :on
      @@state == :on
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
      message = messages[lbl] || lbl.to_s
      time_passed = Time.now.ms_since time_initial
      print "  " * nindent
      printf("stamp: %7dms   #{message}\n", time_passed)
    end
    alias_method :stamp!, :stamp

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
end

Cutter::Stamper.scope :default => "no name" do |default|
end
