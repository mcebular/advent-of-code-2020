
file = File.open("input/day10.txt", "r")
numbers = file.readlines.map{|x| x.to_i}

numbers.push(0) # append zero to input
numbers.sort!
diffs = [0, 0, 0]

for i in 0..numbers.length-2
    a = numbers[i]
    b = numbers[i + 1]
    diff = b - a
    diffs[diff - 1] += 1
end

diffs[2] += 1
puts diffs[0] * diffs[2] # part 1

paths = {}
paths.default = 0

numbers.reverse!
numbers = [numbers[0] + 3] + numbers # prepend max+3 to input
for i in 0..numbers.length-1
    a = numbers[i]
    b = numbers[i+1]

    if i == 0
        paths["#{b} -> #{a}"] = 1
        next
    end

    paths["#{b} -> #{a}"] = paths["#{a} -> #{a+1}"] + paths["#{a} -> #{a+2}"] + paths["#{a} -> #{a+3}"]
    paths["#{b} -> #{a+1}"] = paths["#{a+1} -> #{a+2}"] + paths["#{a+1} -> #{a+3}"] + paths["#{a+1} -> #{a+4}"]
    paths["#{b} -> #{a+2}"] = paths["#{a+2} -> #{a+3}"] + paths["#{a+2} -> #{a+4}"] + paths["#{a+2} -> #{a+5}"]
end

puts paths[" -> 0"]