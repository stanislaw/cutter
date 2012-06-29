require 'spec_helper'
require 'stringio'
describe 'Cutter::Inspection demonstration!'  do

  describe "#inspect" do
    def method_binding first, second, *more
      @instance_var1 = "I am instance var!"
      inspect! binding
      "Return value"
    end

    def method_caller_chain name, *args, &block
      @instance_variable = "I'm instance variable"
      local_variable = "I'm local variable"
      inspect!(:caller) { puts "I'am the string from #inspect method block" }
    end

    def minimal
      inspect!{}
    end

    def instance_variables_test
      @instance_variable = "blip!"
      inspect!(:instance) {}
    end

    def maximal *args
      inspect!(:max) {}
    end

    class SelfInspectDemo
      attr_accessor :variable
      def method_self_inspect name, *args, &block
        @variable = "I'm variable"
        "Return value"
        "Return value"
        "Return value"
        inspect!(:self){}
        "Return value"
      end
    end

    def iii_demo *args
      @instance_var = "blip!"
      iii(:instance){}
    end

    puts "\nNo specs. Just a demonstration of traces!"
    specify { method_binding 1,2,3,4,5 }
    specify { SelfInspectDemo.new.method_self_inspect 1,2,3,4,5 }
    specify { method_caller_chain :"1",2,3,4,5 }
    specify { minimal }
    specify { instance_variables_test }
    specify { maximal 1, :two, 'three', {:four => 5} }
    specify { iii_demo 1, 2, 3 }
  end
end
