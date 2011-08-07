require 'spec_helper'

Stamper.scope :stan => "testing test_method" do |stan|
  stan.msg _1: 'stamp1'
  stan.msg _2: 'stamp2'
  stan.msg _3: 'stamp3'
end


stamper :stan do |s|
  s.stamp
  s.stamp :_1
  sleep 0.1
  s.stamp :_2
  s.stamp :hello_world
  sleep 0.1
  s.stamp :_3
  sleep 0.1
end

