module Cutter
  class Inspection
    class << self
      def quiet!
        @quiet = true
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
  
  def inspect! _local_variables, _binding
    return true if Cutter::Inspection.quiet?
    puts "method: `#{caller[0][/`([^']*)'/,1]}'"
    puts %{  variables:} 
    _local_variables.map do |lv|
      puts %{    #{lv}: #{_binding.eval(lv.to_s)} } 
    end
  end

  def test_inspector
    puts "Cutter is working..."
  end
end
