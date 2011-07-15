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
    level = options[:level]
    _caller = caller
    
    # Basic info
    puts %|\nmethod: `#{eval('__method__', _binding)}'|
    puts %|  called from class: #{eval('self.class', _binding)}|

    lvb = eval('local_variables',_binding)
    puts %|  variables: #{"[]" if lvb.empty?}|
    lvb.map do |lv|
      puts %|    #{lv}: #{eval(lv.to_s, _binding)}| 
    end if lvb

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

end
