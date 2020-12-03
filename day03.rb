
def readArea(lines)
    area = []
    for i in 0..lines.length-1
        line = lines[i]
        area[i] = line.chars[0..line.length-2]
    end
    return area
end

file = File.open("input/day03.txt", "r")
area = readArea(file.readlines)

def treeCountForSlope(area, right, down)
    currentPosition = [0, 0] # [y, x]

    treeCount = 0
    while currentPosition[0] < area.length
        tile = area[currentPosition[0]][currentPosition[1]]
        # puts "There is #{tile} at position #{currentPosition}"
        if tile == "#"
            treeCount += 1
        end
        currentPosition = [currentPosition[0] + down, (currentPosition[1] + right) % (area[0].length-1)]
    end

    return treeCount
end

treeCounts = []
for slope in [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]
    right = slope[0]
    down = slope[1]
    treeCounts.push(treeCountForSlope(area, right, down))
end

puts treeCounts[1] # part 1
puts (treeCounts.reduce { |p, n| p * n } )