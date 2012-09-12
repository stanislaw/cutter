module Cutter
  class Inspection
    class << self
      def quiet!
        @quiet = true
      end

      def loud!
        @quiet = nil
      end

      def quiet?
        @quiet
      end
    end
  end
end

class Object

  # #inspect! may be called inside any method as 'inspect! {}' or more rigorously as 'inspect!(binding)'
  # Binding is a Ruby class: http://www.ruby-doc.org/core/classes/Binding.html

  def inspect! *options, &block
    return true if Cutter::Inspection.quiet?

    # Getting binding
    _binding = options.first if options.first.class == Binding
    raise ArgumentError, "Try inspect(binding) or inspect! {}", caller if (!block_given? && !_binding)
    _binding ||= block.binding

    max = true if options.include? :max
    options << :instance << :max << :self << :caller if max
    options.uniq!

    iv = true if options.include? :instance

    # Want caller methods chain to be traced? - pass option :caller to #inspect!
    _caller = true if options.include? :caller

    self_inspection = eval('self.inspect', _binding) if options.include? :self

    # Basic info
    method_name = eval('__method__', _binding)
    class_name = eval('self.class', _binding)

    if method_name && (meth = method(method_name.to_sym)).respond_to?(:source_location)
      source_path, source_number = meth.source_location
    end

    puts "\n%s `%s' %s" % ['method:'.__colorize__(:method), method_name.__colorize__(:method_name), ('(maximal tracing)' if max)]

    puts "  %s %s:%s" % ['source_location:'.__colorize__(:source), source_path.dup.__colorize__(:source_path), source_number.to_s.__colorize__(:source_number)] if source_path && source_number

    puts "  %s %s" % ['called from class:'.__colorize__(:called_from), class_name.__colorize__(:class_name)]

    # Local Variables
    lvb = eval('local_variables',_binding)
    puts "  %s %s" % ['local_variables:'.__colorize__(:lv), ("[]" if lvb.empty?)]

    lvb.map do |lv|
      local_variable = eval(lv.to_s, _binding)
      local_variable = (max ? local_variable.inspect : local_variable.__real_to_s__)

      puts "    %s: %s" % [lv.__colorize__(:lv_names), local_variable.__colorize__(:lv_values)]
    end if lvb

    # Instance Variables
    begin
      ivb = eval('instance_variables',_binding)

      puts "  %s %s" % ["instance_variables:".__colorize__(:iv), ("[]" if ivb.empty?)]

      ivb.map do |iv|
        instance_variable = eval(iv.to_s, _binding)
        instance_variable = (max ? instance_variable.inspect : instance_variable.__real_to_s__)

        puts "    %s: %s" % [iv.__colorize__(:iv_names), instance_variable.__colorize__(:iv_values)]
      end if ivb
    end if iv

    # Self inspection
    begin
      puts "  self inspection:".__colorize__(:self_inspection)
      puts "  %s" % self_inspection.__colorize__(:self_inspection_trace)
    end if self_inspection

    # Caller methods chain
    begin
      puts "  caller methods: ".__colorize__(:caller_methods)
      caller.each do |meth|
        puts "  %s" % meth.__colorize__(:caller_method)
      end
    end if _caller

    puts "\n"

    # Yield mysterious things if they exist in block.
    yield if block_given?
  end

  alias :iii :inspect!

  protected

  # "Real string". It is now used to print Symbols with colons
  def __real_to_s__
    case self
    when Symbol, Array, Hash
      inspect
    else
      to_s
    end
  end
end

class Object
  def rrr object = nil
    raise object.inspect
  end

  def ppp object = nil
    puts object.inspect
  end

  def lll object = nil
    Rails.logger.info object.inspect
  end if defined? Rails
end

# def caller_method_name(level = 1)
#   caller[level][/`([^']*)'/,1].to_sym
# end


