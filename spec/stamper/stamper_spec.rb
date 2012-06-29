require 'spec_helper'
require 'stringio'

# http://thinkingdigitally.com/archive/capturing-output-from-puts-in-ruby/

module Kernel
  def capture_stdout
    out = StringIO.new
    $stdout = out

    yield

    out
  ensure
    $stdout = STDOUT
  end
end

Cutter::Stamper.scope :stan => "testing test_method" do |stan|
  stan.msg _1: 'stamp1'
  stan.msg _2: 'stamp2'
  stan.msg _3: 'stamp3'
end

Cutter::Stamper.colors do |colors|
  colors[:line]  = :blue
  colors[:stamp] = :green
end

class Context
  def test_method &block
    stamper :stan do |s|
      stamp :_1
      sleep 0.1
      stamp :_2
      sleep 0.1
      yield if block
      stamp :_3
      sleep 0.1
    end
  end
end

describe Cutter::Stamper do 

  it "should produce stamps" do
    out = capture_stdout do 
      Context.new.test_method
    end
    result = out.string
    result.should match(/testing test_method/)
    result.should match(/stamp1/)
    result.should match(/stamp2/)
    result.should match(/stamp3/)
  end

  it "should define #stamp! helper method in the context #stamper was called" do
    out = capture_stdout do
      context = Context.new
      context.test_method do
        context.should respond_to :stamp
      end
    end
  end
  
  it "should undefine #stamp! helper method after the context #stamper was called was run" do
    out = capture_stdout do
      context = Context.new
      context.test_method
      context.should_not respond_to :stamp
    end
  end
end
