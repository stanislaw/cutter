# Cutter

Two-methods-gem I use a lot for simple debugging & performance measuring purposes.

```#inspect``` method shines when doing reverse engineering, it is especially useful, when it is needed to quickly hack on someone else's code. Also, it is very easy to become 'someone else' for self, when dealing with own code, if it was written very long time ago.

Besides that ```#stamper``` allows doing performance measuments in a handy manner, it can be used to create quick and neat demonstrations of how particular pieces of Ruby code perform. 

The one interesting possible usage of ```#stamper``` is performance optimization of templates on Rails View Layer, because it often takes a large load impact (compared to M and C layers) because of Rails lazy-evaluation mechanisms.

[![Build Status](https://secure.travis-ci.org/stanislaw/cutter.png)](http://travis-ci.org/stanislaw/cutter)

## Prerequisites

It works on 1.8.7, 1.9.3, JRuby and Rubinius.

## Installiation

Include it into Gemfile:

```ruby
group :development, :test do
  gem 'cutter'
end
```

## Cutter::Inspection

### I) #inspect!

Insert ```#inspect!``` method into any of your methods:

```ruby
  def your_method *your_args
    # ...
    
    inspect! {} # curly braces are important - they capture original environment!    
    
    # or 
    # iii {} as an alias
    
    # ...
  end

  # your_method(1,"foo",:bar) => 
  
  # method `your_method'
  #   variables: 
  #     your_args: [1, "foo", :bar]
```

It gives simple but nice trace for inspection: method's name and args that were passed to method.

With ```inspect!(:instance) {}``` we also see instance variables:

```ruby
  def your_method a, b 
    @instance_var = "blip!"
    inspect!(:instance) {}
  end

  # your_method 1, 2
  # method: `your_method' 
  #   called from class: RSpec::Core::ExampleGroup::Nested_1::Nested_1
  #   local_variables: 
  #     a: 1
  #     b: 2
  #   instance_variables: 
  #     @instance_var: blip!
```

With ```inspect!(:self) {}``` we have ```self#inspect``` of class to which method belongs to:

```ruby  
  def your_method name, *args
    # ...
    inspect!(:self) {}
  end

  # your_method(1,2,3,4,5) =>
  
  # method: `your_method'
  #   called from class: SelfInspectDemo
  #   variables: 
  #     name: 1
  #     args: [2, 3, 4, 5]
  #     block: 
  #   self inspection:
  #     #<SelfInspectDemo:0x82be488 @variable="I'm variable">
```

Option ```:caller``` gives us caller methods chain:

```ruby  
  def your_method name, *args
    # ...
    inspect!(:caller) {}
  end

  # your_method(1,2,3,4,5) => 
  
  # method: `your_method'
  #   called from class: RSpec::Core::ExampleGroup::Nested_1::Nested_1
  #   variables: 
  #     name: 1
  #     args: [2, 3, 4, 5]
  #     block: 
  #   caller methods: 
  #     /home/stanislaw/_work_/gems/cutter/spec/inspection/demo_spec.rb:33:in `your_method'
  #     /home/stanislaw/_work_/gems/cutter/spec/inspection/demo_spec.rb:40:in `block (3 levels) in <top (required)>' 
  #     /home/stanislaw/.rvm/gems/ruby-1.9.2-p180@310/gems/rspec-core-2.6.4/lib/rspec/core/example.rb:48:in `instance_eval'
```

And finally ```inspect!(:max) {}``` produces maximum information: options ```:instance```, ```:self```, ```:caller``` are included and **Ruby's ordinary ```#inspect``` method is called on every variable**.

```ruby
  def your_method *args
    inspect!(:max) {}
  end

  # maximal(1, :two, "three", :four => 5) =>
  #
  # method: `your_method' (maximal tracing)
  #   called from class: RSpec::Core::ExampleGroup::Nested_1::Nested_1
  #   local_variables: 
  #     args: [1, :two, "three", {:four=>5}]
  #   instance_variables: 
  #     @example: #<RSpec::Core::Example:0xa1d378 >
  #     ...
  #   self inspection:
  #   #<RSpec::Core::ExampleGroup::Nested_1::Nested_1:0x9e5f8f4
  #   ...
  #   caller methods: 
  #   /home/stanislaw/work/gems/cutter/spec/inspection/demo_spec.rb:28:in `maximal'
  #   /home/stanislaw/work/gems/cutter/spec/inspection/demo_spec.rb:54:in `block (3 levels) in <top (required)>'
  #   ...
```

If you want all ```#inspect!``` methods fall silent at once, use

```ruby
Cutter::Inspection.quiet!
```

To make them sound again do

```ruby
Cutter::Inspection.loud!
```

### Three-letters methods

```ruby
class Object
  def rrr object = nil
    raise object.inspect
  end

  def ppp object = nil
    puts object.inspect
  end

  def lll object = nil
    Rails.logger.info object.inspect
  end if defined? Rails
end
```

### #iii

Instead of ```#inspect!``` you can use ```#iii``` - just an alias more convenient for typing. 

Finally, you have a group of 4 three-letters methods in your every day debugging workflow.

## II) Cutter::Stamper

Acts as ```benchmark {}``` in Rails or ```Benchmark.measure {}``` in common Ruby, but with stamps in any position in block executed.

It is much simpler to write Stamper with Stamps than all these Measure-dos.

### Minimal stamper

```stamp!``` method is just an alias for ```stamp```, use whatever you like:

```ruby
puts "Minimal stamper"
stamper do
  stamp
  sleep 0.2
  stamp! 
  sleep 0.2
  stamp!
end
```

Will produce:

```text
Minimal stamper

no name
-------
  stamp:       0 ms   
  stamp:     200 ms   
  stamp:     400 ms   
-------
  400ms
```

### Stamper with named stamps

```ruby
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
  tm.stamp! :_1 # The old form of calling #stamp! on yielded scope
  variable
  sleep 0.3
  stamper :inner_scope do |i|
    sleep 0.2
    i.stamp! :first
    sleep 0.2
    i.stamp! "Stamp with custom text"
  end
  tm.stamp! :_2
end
```

will result in

```text
Now with named stamps

Demonstration of named stamping
-------------------------------
  stamp:     300 ms   first piece

    Now internal things
    -------------------
    stamp:     201 ms   I'm the first inner stamp
    stamp:     401 ms   Stamp with custom text
    -------------------
                  401ms

  stamp:    1001 ms   second piece
-------------------------------
                         1001ms
```

### Stamper with ```:capture => true``` option

Use it to hide the output of piece you are benchmarking.

```ruby
require 'cutter'

N = 100000

result = []

EMB = "String to embed"

result << stamper(:capture => true) do
  N.times do
    puts "#{EMB}\n"
  end
end

result << stamper(:capture => true) do
  N.times do
    printf "#{EMB}\n"
  end
end

result << stamper(:capture => true) do
  N.times do
    print "#{EMB}\n"
  end
end

puts result.inspect
```

## Notes

* Both ```#inspect! {}``` and ```#stamper``` methods colorize their output. You can see ```lib/cutter/colored_output.rb``` file to understand how it is done. I will really appreciate any suggestions of how current color scheme can be improved.

## Specs and demos

Clone it

```bash
$ git clone https://github.com/stanislaw/cutter
$ cd cutter
```

Specs are just

```ruby
rake
```

See demos

```ruby
rake demo
```

## Contributors

* Stanislaw Pankevich
* Kristian Mandrup

## Copyright

Copyright (c) 2011 Stanislaw Pankevich
