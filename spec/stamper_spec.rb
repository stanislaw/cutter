require 'spec_helper'
Cutter::Stamper.scope :stan => "testing test_method" do |stan|
  stan.msg :_1 => 'stamp1'
  stan.msg :_2 => 'stamp2'
  stan.msg :_3 => 'stamp3'
end

Cutter::Stamper.colors do |colors|
  colors[:line]  = :blue
  colors[:stamp] = :green
end

class Context
  def test_method &block
    stamper :stan do |s|
      sleep 0.05
      stamp :_1
      sleep 0.06
      stamp :_2
      sleep 0.07
      stamp!
      sleep 0.08
      yield if block
      stamp :_3
      sleep 0.09
    end
  end
  
  def test_method_with_capture &block
    stamper(:stan, :capture => true) do |s|
      sleep 0.05
      stamp :_1
      sleep 0.06
      stamp :_2
      print("Block has output")
      sleep 0.07
      stamp!
      sleep 0.08
      yield if block
      stamp :_3
      sleep 0.09
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

  it "should produce milliseconds marks" do
    out = capture_stdout do
      Context.new.test_method
    end
    result = out.string

    result.should match /\d+ms/
  end

  describe "#stamper" do
    it "should return '(time)ms'" do
      out = capture_stdout do
        Context.new.test_method.should match /\d+ms/
      end
    end
  
    describe ":capture => true" do
      it "should capture the output block has" do
        out = capture_stdout do
          Context.new.test_method_with_capture
        end

        result = out.string
        result.should_not match /Block has output/
      end
    end
  end

  [:stamp, :stamp!].each do |meth|
    describe "##{meth}" do 
      it "should define ##{meth} helper method in the context #stamper was called" do
        out = capture_stdout do
          context = Context.new
          context.test_method do
            context.should respond_to meth
          end
        end
      end

      it "should undefine ##{meth} helper method after the context #stamper was called was run" do
        out = capture_stdout do
          context = Context.new
          context.test_method
          context.should_not respond_to :meth
        end
      end
    end
  end
end
