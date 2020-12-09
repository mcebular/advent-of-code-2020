require 'set'

file = File.open("input/day09.txt", "r")
numbers = file.readlines.map{|x| x.to_i}

preambleSize = 25 # is an input param!

def findSum(nums, wantedSum)
    for i in 0..nums.length-1
        for j in 0..nums.length-1
            if nums[i] + nums[j] == wantedSum
                return true
            end
        end
    end
    return false
end

invalidNum = -1
for i in 0..numbers.length-1
    numRange = numbers[i..i+preambleSize-1]
    currentNum = numbers[i+preambleSize]
    if !findSum(numRange, currentNum)
        invalidNum = currentNum
        break
    end
end

puts invalidNum # part 1

for i in 0..numbers.length-1
    for j in i..numbers.length-1
        tmp = numbers[i..j]
        if tmp.length == 1
            next
        end
        if tmp.sum == invalidNum
            puts tmp.min + tmp.max # part 2
            break
        end
    end
end