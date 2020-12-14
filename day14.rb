
file = File.open("input/day14.txt", "r")
lines = file.readlines

def floatingPositions(mask)
    i = mask.index("X")
    if i == nil
        # puts mask
        return [mask]
    end

    return floatingPositions(mask.sub("X", "1")) + floatingPositions(mask.sub("X", "0"))
end

memory1 = {}
memory2 = {}

raw_mask = ""
mask = [0, 0]
for i in 0..lines.length-1
    line = lines[i]

    if line.start_with?("mask")
        raw_mask = line.split(" = ")[1].strip
        ones = raw_mask.gsub("X", "0").to_i(2)
        zeros = raw_mask.gsub("1", "X").gsub("0", "1").gsub("X", "0").to_i(2)
        mask = [zeros, ones]
        next
    end

    rx = /mem\[([0-9]+)\] = ([0-9]+)/
    md = rx.match(lines[i])
    pos = md[1].to_i
    val = md[2].to_i


    # part 1 #
    maskedVal = ~(~(val | mask[1]) | mask[0])
    memory1[pos] = maskedVal
    ##########

    # part 2 #
    tmp = (pos | ones).to_s(2)
    while tmp.length < 36
        tmp = "0" + tmp
    end
    for i in 0..raw_mask.length-1
        if raw_mask[i] == "X"
            tmp[i] = "X"
        end
    end
    positions = floatingPositions(tmp)

    for pstr in positions
        memory2[pstr.to_i(2)] = val
    end
    ##########

end

puts memory1.values.sum
puts memory2.values.sum