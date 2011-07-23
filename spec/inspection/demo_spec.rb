require 'spec_helper'
require 'stringio'
 
describe 'Cutter::Inspection demonstration!'  do 

  describe "#inspect" do
    def method_binding first, second, *more
      inspect! binding
      "Return value"
    end

    def method_block name, *args, &block
      "Return value"
      "Return value"
      "Return value"
      inspect! {}
      "Return value"
    end

    class SelfInspectDemo
    attr_accessor :variable
    def method_self_inspect name, *args, &block
      @variable = "I'm variable"
      "Return value"
      "Return value"
      "Return value"
      inspect!(:inspect => true) {}
      "Return value"
    end
    end

    puts "\nNo specs. Just a demonstration of traces!"
    specify { method_binding 1,2,3,4,5 }
    specify { method_block 1,2,3,4,5 }
    specify { SelfInspectDemo.new.method_self_inspect 1,2,3,4,5 }
  end 
end
