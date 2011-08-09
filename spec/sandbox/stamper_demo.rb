require 'spec_helper'

Cutter::Stamper.scope :stan => "Performance testing test_method" do |stan|
  stan.msg _1: 'stamp1'
  stan.msg _2: 'stamp2'
  stan.msg _3: 'stamp3'
end

Cutter::Stamper.scope :hello => "testing hello part" do |stan|
  stan.msg _1: 'Piece code #1 hello Stan performed'
  stan.msg _2: 'Caching of ability was run'
end

Cutter::Stamper.colors do |colors|
end

Cutter::Stamper.turn_colors :on

v = 32

stamper :stan do |s|
  s.stamp
  s.stamp :_1
  sleep 0.1
  Cutter::Stamper.turn :off
  s.stamp :_2
  s.stamp :evil!
  Cutter::Stamper.loud!
  s.stamp :hello_world
  stamper :hello do |s|
    s.stamp :_1
    sleep 0.1
    s.stamp :_2
  end
  sleep 0.1
  s.stamp "hello world: #{v}" # access var before block
  s.stamp :_3
  s.stamp
  sleep 0.1
end

describe 'Minimal Stamper' do
  it 'should trace' do
    stamper {
    }
  end
end
