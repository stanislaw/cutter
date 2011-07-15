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

    specify { method_binding 1,2,3,4,5 }
    specify { method_block 1,2,3,4,5 }
  end 
end
