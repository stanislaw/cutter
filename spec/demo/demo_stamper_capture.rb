require 'cutter'

N = 1000

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
