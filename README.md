# Cutter

Two-methods-gem I use a lot for simple debugging & performance measuring purposes.

Include it into Gemfile:

```ruby
group :development, :test do
  gem 'cutter'
end
```

## I) #inspect! 

Insert #inspect! method into any of your methods:

```ruby
  def your_method *your_args
    inspect! {} # this string exactly!    
    ...
  end

  # your_method(1,"foo",:bar) => 
  
  # method `your_method'
  #   variables: 
  #     args: [1, "foo", :bar]
```

or in more rigorous way:

```ruby
  def your_another_method(first, second, third, &block)
    inspect!(binding)
  end
  
  # your_another_method(1,"foo",:bar) => 
  
  # method `your_another_method'
  #   variables: 
  #     first: 1
  #     second: "foo"
  #     third: :bar
  #     block: 
```

Gives simple but nice trace for inspection: method's name and args that were passed to method

With inspect!(:self) we have self#inspect of class to which method belongs to:

```ruby  
  def method_self_inspect
    ...
    inspect!(:self) {}
  end

  # method_self_inspect(1,2,3,4,5) =>
  
  # method: `method_self_inspect'
  #   called from class: SelfInspectDemo
  #   variables: 
  #     name: 1
  #     args: [2, 3, 4, 5]
  #     block: 
  #   self inspection:
  #     #<SelfInspectDemo:0x82be488 @variable="I'm variable">
```

And finally :caller gives caller methods chain:

```ruby  
  def method_caller_chain
    ...
    inspect!(:caller)
  end

  # method_caller_chain(1,2,3,4,5) => 
  
  # method: `method_caller_chain'
  #   called from class: RSpec::Core::ExampleGroup::Nested_1::Nested_1
  #   variables: 
  #     name: 1
  #     args: [2, 3, 4, 5]
  #     block: 
  #   caller methods: 
  #     /home/stanislaw/_work_/gems/cutter/spec/inspection/demo_spec.rb:33:in `method_caller_chain'
  #     /home/stanislaw/_work_/gems/cutter/spec/inspection/demo_spec.rb:40:in `block (3 levels) in <top (required)>' 
  #     /home/stanislaw/.rvm/gems/ruby-1.9.2-p180@310/gems/rspec-core-2.6.4/lib/rspec/core/example.rb:48:in `instance_eval'
```

If you want all #inspect! methods fall silent at once, use
```Cutter::Inspection.quiet!```
To make them sound again do
```@Cutter::Inspection.loud!```

You can clone it and try 

```ruby
@bundle exec rspec spec/inspection/demo_spec.rb@
```  
Very! Very simple!

## II) #stamper

Description is coming...

Acts as self.benchmark{} (in Rails) or Benchmark.measure{} (common Ruby) but with stamps in any position in block executed.
It is much simpler to write it quickly than all these Measure-dos.

## Contributors

* Stanislaw Pankevich
* Kristian Mandrup

## Copyright

Copyright (c) 2011 Stanislaw Pankevich
