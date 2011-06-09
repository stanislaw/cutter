require 'active_support'
require 'spec_helper'

require 'stringio'
require 'active_support'
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

  def test_method
    stamper("testing test_method") do
      stamp('stamp1')
      sleep 0.1
      stamp('stamp2')
      sleep 0.1
      stamp('stamp3')
      sleep 0.1
    end
  end

  it "does stamps" do
    out = capture_stdout do 
      test_method
    end
    result = out.string
    result.should match(/testing test_method/)
    result.should match(/stamp1/)
    result.should match(/stamp2/)
    result.should match(/stamp3/)
  end
end
