require 'spec_helper'

describe Cutter do
  it 'should have a VERSION' do
    Cutter.const_defined?(:VERSION).should == true
  end
end
