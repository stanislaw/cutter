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
  # For now inspect! method only may be used with two arguments (local_variables, binding)
  # Binding is a Ruby class: http://www.ruby-doc.org/core/classes/Binding.html
  
  def inspect! _binding = nil, &block
    return true if Cutter::Inspection.quiet?
    raise ArgumentError, "Try inspect(binding) or inspect! {}", caller if (!block_given? && !_binding)
    _binding ||= block.binding
    puts %|method: `#{caller_method_name}'|
    lvb = eval('local_variables',_binding)
    puts %|  variables: #{"[]" if lvb.empty?}|
    lvb.map do |lv|
      puts %|    #{lv}: #{eval(lv.to_s, _binding)}| 
    end if lvb
    yield if block_given?
  end

  def caller_method_name(level = 1)
    caller[level][/`([^']*)'/,1].to_sym
  end

end
