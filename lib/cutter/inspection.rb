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
    
    # Want caller methods chain to be traced? - pass option :level to inspect!
    options = options.extract_options! 
    
    max = options[:max]
    options.maximize_options! if max 
   
    level = options[:level]
    _caller = caller
   
    self_inspection = eval('self.inspect', _binding) if options[:inspect]

    # Basic info
    puts %|\nmethod: `#{eval('__method__', _binding)}' #{'(maximal tracing)' if max}|
    puts %|  called from class: #{eval('self.class', _binding)}|

    lvb = eval('local_variables',_binding)
    puts %|  local_variables: #{"[]" if lvb.empty?}|

    lvb.map do |lv|
      local_variable = eval(lv.to_s, _binding)
      local_variable = (max ? local_variable.inspect : local_variable.to_real_string)

      puts %|    #{lv}: #{local_variable}| 
    end if lvb

    ivb = eval('instance_variables',_binding)
    puts %|  instance_variables: #{"[]" if ivb.empty?}|
    
    ivb.map do |lv|
      instance_variable = eval(lv.to_s, _binding)
      instance_variable = (max ? instance_variable.inspect : instance_variable.to_real_string)
     
      puts %|    #{lv}: #{instance_variable}| 
    end if ivb

    # Self inspection 
    begin
      puts %|  self inspection:|
      puts %|    #{self_inspection}|
    end if self_inspection

    # Caller methods chain
    begin
    puts %|  caller methods: |
    0.upto(level).each {|index|
      puts %|    #{_caller[index]}|
    }
    end if level
   
    puts "\n"
    # Yield mysterious things if they exist in block.
    yield if block_given? 
  end

  def caller_method_name(level = 1)
    caller[level][/`([^']*)'/,1].to_sym
  end

  protected

  def maximize_options!
    self.merge!({:max => true, :inspect => true, :level => 2})
  end

  def to_real_string
    return ":#{self.to_s}" if self.class == Symbol
    self
  end
end

