class Object
  
  # For now #inspect! should be used with arguments: (local_variables,binding)
  def inspect! _local_variables, _binding
    puts "method: `#{caller[0][/`([^']*)'/,1]}'"
    puts %{  variables:} 
    _local_variables.map do |lv|
      puts %{    #{lv}: #{eval(lv.to_s,_binding)} } 
    end
  end

  def test_inspector
    puts "Cutter is working..."
  end
end
