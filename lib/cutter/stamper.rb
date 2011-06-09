class Object
  def time_now
    Time.now.strftime("%s%L").to_i
  end

  def stamper(message = nil, &block) 
    def stamp(message = "<no subj>")
      time_passed = time_now - @time_initial
      puts("~ testing: #{message}, #{time_passed}ms")
    end
    puts("~ #{message}")
    puts("~ testing: start")
    @time_initial = time_now
    yield
    time_passed = time_now - @time_initial
    puts("~ testing: end (#{time_passed}ms)")
  end

end
