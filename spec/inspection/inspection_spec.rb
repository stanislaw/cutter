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

shared_examples_for "#inspect! method working right!" do
  it "should print name of the function and its local variables" do
    Cutter::Inspection.loud!
    result = output.string
    result.should match(/first arg/)
    result.should match(/12345/)
    result.should match(/:test/)
  end

  it "should print nothing if Inspection was turned off by #quiet!" do
    Cutter::Inspection.quiet!
    result = output.string
    result.should be_empty 
  end
end

describe Cutter::Inspection do 

  describe "#inspect" do
    def method_binding *args, &block
      inspect! binding
      "Return value"
    end

    def method_block *args, &block
      "Return value"
      "Return value"
      "Return value"
      inspect! {}
      "Return value"
    end

    describe "given with binding as arg" do
      let(:output) { 
        capture_stdout do 
          method_binding "first arg",12345,:test 
        end
      }
      it_should_behave_like "#inspect! method working right!" 
    end

    describe "given with block" do
      let(:output) { 
        capture_stdout do
          method_block "first arg", 12345, :test 
        end
      }
      
      it_should_behave_like "#inspect! method working right!"
      
      subject { method_block "first arg", 12345, :test }
      it { should == ("Return value")}
    end

    describe 'called without args' do
      def method_without_args *args
        "various stuff"
        inspect!
        "various stuff"
      end

      subject{ method_without_args 1,2,3 }
      it { should raise_exception }
    end

    describe 'called in method having no arguments' do
      def method_having_no_args
        "various stuff"
        inspect! {}
        "various stuff"
      end

      subject{ method_having_no_args }
      it { should == "various stuff" }
    end
    
    describe "given with :inspect option" do
      Cutter::Inspection.loud!
      class SomeClass
        attr_accessor :test_var

        def initialize
          @test_var = "I am test var!"
        end

        def method_inspected *args
          inspect!(:inspect => true){}
        end
      end
      
      a = capture_stdout do
        SomeClass.new.method_inspected
      end
    
      subject {a.string}
        it {should match(/SomeClass/)}
        it {should match(/@test_var/)}
        it {should match(/I am test var!/)}
    end

  end 
end
