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

Stamper.scope :stan => "testing test_method" do |stan|
  stan.msg _1: 'stamp1'
  stan.msg _2: 'stamp2'
  stan.msg _3: 'stamp3'
end

Stamper.colors do |colors|
  colors.line :blue
  colors.stamp :green
end

describe "Stamper" do 

  def test_method
    stamper :stan do |s|
      s.stamp :_1
      sleep 0.1
      s.stamp :_2
      sleep 0.1
      s.stamp :_3
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
