require 'spec_helper'

Stamper.scope :stan => "testing test_method" do |stan|
  stan.msg _1: 'stamp1'
  stan.msg _2: 'stamp2'
  stan.msg _3: 'stamp3'
end

Stamper.scope :hello => "testing hello part" do |stan|
  stan.msg _1: 'hello stan'
  stan.msg _2: 'nice to see you'
end

Stamper.colors do |colors|
  colors[:line]   = :green
  colors[:time]   = :yellow
  colors[:stamp]  = :green
end

v = 32

stamper :stan do |s|
  s.stamp
  s.stamp :_1
  sleep 0.1
  Stamper.turn :off
  s.stamp :_2
  s.stamp :evil!
  Stamper.turn :on
  s.stamp :hello_world
  stamper :hello do |s|
    s.stamp :_1
    sleep 0.1
    s.stamp :_2
  end
  sleep 0.1
  s.stamp "hello world: #{v}" # access var before block
  s.stamp :_3
  sleep 0.1
end

describe 'it' do
  it 'works' do
  end
end

