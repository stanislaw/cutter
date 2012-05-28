# Cutter

Two-methods-gem I use a lot for simple debugging & performance measuring purposes.

Include it into Gemfile:

```ruby
group :development, :test do
  gem 'cutter'
end
```

## I) #inspect! (or #iii - it is an alias)

Insert #inspect! method into any of your methods:

```ruby
  def your_method *your_args
    # ...
    inspect! {} # curly braces are important!    
    # ...
  end

  # your_method(1,"foo",:bar) => 
  
  # method `your_method'
  #   variables: 
  #     your_args: [1, "foo", :bar]
```

It gives simple but nice trace for inspection: method's name and args that were passed to method.

With ```inspect!(:instance){}``` we also see instance variables:

```ruby
  def your_method a, b 
    @instance_var = "blip!"
    inspect!(:instance){}
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

With ```inspect!(:self){}``` we have self#inspect of class to which method belongs to:

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

Option :caller gives us caller methods chain:

```ruby  
  def your_method name, *args
    # ...
    inspect!(:caller)
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

And finally ```inspect!(:max){}``` produces maximum information: options
:instance, :self, :caller are included + Ruby's ordinary #inspect method
is called on every variable.

```ruby
  def your_method *args
    inspect!(:max){}
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

If you want all #inspect! methods fall silent at once, use

```ruby
Cutter::Inspection.quiet!
```

To make them sound again do

```ruby
Cutter::Inspection.loud!
```

You can clone it and try 

```ruby
bundle exec rspec spec/inspection/demo_spec.rb
```  

Very! Very simple!

### Notes
1. Instead of #inspect! you can use #iii - just an alias more convenient for typing.
2. #inspect! colorizes its output. If somebody suggests even better color scheme, I will be thankful.

## II) #stamper

Acts as benchmark{} in Rails or Benchmark.measure{} (common Ruby) but with stamps in any position in block executed.
It is much simpler to write it quickly than all these Measure-dos.

Description is coming...

```ruby
bundle exec rspec spec/stamper/demo_spec.rb
```

## Contributors

* Stanislaw Pankevich
* Kristian Mandrup

## Copyright

Copyright (c) 2011 Stanislaw Pankevich
