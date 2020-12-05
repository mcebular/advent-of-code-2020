
file = File.open("input/day05.txt", "r")
lines = file.readlines

def parseBoardingPass(line)
    front = 0
    back = 127
    left = 0
    right = 7
    for ch in line.chars
        rangeFB = (back - front + 1) / 2
        rangeRL = (right - left + 1) / 2
        # puts "f: #{front}, b: #{back}, r: #{range}"
        if (ch == "F")
            back -= rangeFB
        elsif (ch == "B")
            front += rangeFB
        elsif (ch == "R")
            left += rangeRL
        elsif (ch == "L")
            right -= rangeRL
        else
            puts "invalid char"
        end

    end
    # puts "#{line}, f: #{front}, b: #{back}, l: #{left}, r: #{right}"
    return front * 8 + left
end

boardingPasses = lines.map {|x| parseBoardingPass(x.strip)}.sort

# last item is max since they're sorted
puts boardingPasses.last # part 1

for i in 1..boardingPasses.length-2
    bp1 = boardingPasses[i-1]
    bp2 = boardingPasses[i]
    bp3 = boardingPasses[i+1]
    if bp1 + 1 != bp2 || bp3 - 1 != bp2
        puts bp2 + 1 # part 2
        break
    end
end