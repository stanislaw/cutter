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
  
  # #inspect! may be called inside any method as 'inspect! {}' or more rigorous: 'inspect!(binding)'
  # Binding is a Ruby class: http://www.ruby-doc.org/core/classes/Binding.html
  
  def inspect! *options, &block
    return true if Cutter::Inspection.quiet?

    # Getting binding
    _binding = options.first if options.first.class == Binding
    raise ArgumentError, "Try inspect(binding) or inspect! {}", caller if (!block_given? && !_binding)
    _binding ||= block.binding
    
    options = options.extract_options! 
    
    max = options[:max]
    options.maximize_options! if max 

    # Want caller methods chain to be traced? - pass option :level to inspect!
    level = options[:level]
    _caller = caller
   
    self_inspection = eval('self.inspect', _binding) if options[:inspect]

    # Basic info
    method_name = eval('__method__', _binding)
    class_name = eval('self.class', _binding)
    
    puts "\n%s `%s' %s" % ['method:'.__cs(:method), method_name.__cs(:method_name), ('(maximal tracing)' if max)]
    puts "  %s %s" % ['called from class:'.__cs(:called_from), class_name.__cs(:class_name)]

    # Local Variables
    lvb = eval('local_variables',_binding)
    puts "  %s %s" % ['local_variables:'.__cs(:lv), ("[]" if lvb.empty?)]

    lvb.map do |lv|
      local_variable = eval(lv.to_s, _binding)
      local_variable = (max ? local_variable.inspect : local_variable.__rs)

      puts "    %s: %s" % [lv.__cs(:lv_names), local_variable.__cs(:lv_values)] 
    end if lvb

    # Instance Variables
    ivb = eval('instance_variables',_binding)
    
    puts "  %s %s" % ["instance_variables:".__cs(:iv), ("[]" if ivb.empty?)]
    
    ivb.map do |iv|
      instance_variable = eval(iv.to_s, _binding)
      instance_variable = (max ? instance_variable.inspect : instance_variable.__rs)
     
      puts "    %s: %s" % [iv.__cs(:iv_names), instance_variable.__cs(:iv_values)] 
    end if ivb

    # Self inspection 
    begin
      puts "  self inspection:".__cs(:self_inspection)
      puts "    %s" % self_inspection.__cs(:self_inspection_trace)
    end if self_inspection

    # Caller methods chain
    begin
    puts "  caller methods: ".__cs(:caller_methods)
    0.upto(level).each {|index|
      puts "    %s" % _caller[index].__cs(:caller_method)
    }
    end if level
   
    puts "\n"
    # Yield mysterious things if they exist in block.
    yield if block_given? 
  end

  protected

  def caller_method_name(level = 1)
    caller[level][/`([^']*)'/,1].to_sym
  end

  def maximize_options!
    self.merge!({:max => true, :inspect => true, :level => 2})
  end

  # ("real string") Now used to print Symbols with colons
  def __rs
    return ":#{self.to_s}" if self.class == Symbol
    self
  end

  def __cs obj
    color = __colors[obj] || :default
    color != :default ? to_s.send(color) : to_s
  end

  private

  def __colors
    Cutter::ColoredOutputs.colors_config
  end

end

