require 'spec_helper'
require 'stringio'
 
# http://thinkingdigitally.com/archive/capturing-output-from-puts-in-ruby/
module Kernel
  def capture_stdout
    out = StringIO.new
    $stdout = out
    yield
    return out
    ensure
    $stdout = STDOUT
  end
end

describe Cutter::Inspection do 

  describe "#inspect" do
    def test_method *args, &block
      inspect! local_variables, binding
    end

    it "should print name of the function and its local variables" do
      out = capture_stdout do 
        test_method "first arg",12345,:test
      end
      result = out.string
      result.should match(/first arg/)
      result.should match(/12345/)
      result.should match(/:test/)
    end

    it "should print nothing if Inspection was turned off by #quiet!" do
      Cutter::Inspection.quiet!
      out = capture_stdout do 
        test_method "first arg",12345,:test
      end
      result = out.string
      result.should be_empty 
    end
  end 
end
