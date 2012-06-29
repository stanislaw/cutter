require 'spec_helper'

describe Cutter do
  describe 'VERSION' do
    it 'should have a VERSION' do
      Cutter.const_defined?(:VERSION).should == true
    end

    it 'should be formatted as x.x.x' do
      Cutter::VERSION.should match /^\d+\.\d+.\d+$/
    end
  end
end
