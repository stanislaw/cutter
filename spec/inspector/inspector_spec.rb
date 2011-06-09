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

describe "Inspection methods" do 


  def test_method *args, &block
    inspect! local_variables, binding
  end

  it "print name of the function and its local variables" do
    out = capture_stdout do 
      test_method "first arg",12345,:test
    end
    result = out.string
    result.should match(/first arg/)
    result.should match(/12345/)
    result.should match(/:test/)
  end
end
