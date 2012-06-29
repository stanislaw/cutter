require 'spec_helper'
require 'colorize'

puts "\n== #stamper and #stamp methods demonstration ==\n".red

puts "The most basic usage"
stamper do |s|
  stamp
  sleep 0.2
  stamp
  sleep 0.2
  stamp
end

puts "Now with named stamps"

Cutter::Stamper.scope :testing_method => "Demonstration of named stamping" do |tm|
  tm.msg _1: "first piece"
  tm.msg _2: "second piece"
end

Cutter::Stamper.scope :inner_scope => "Now internal things" do |i|
  i.msg first: "I'm the first inner stamp"
end

stamper :testing_method do |tm|
  sleep 0.3
  tm.stamp :_1
  sleep 0.3
  stamper :inner_scope do |i|
    sleep 0.2
    i.stamp :first
    sleep 0.2
    i.stamp "Stamp with custom text"
  end
  tm.stamp :_2
end

puts "\n== #stamper and #stamp methods demonstration ENDS! ==\n".red

