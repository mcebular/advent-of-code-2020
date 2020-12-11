
file = File.open("input/day11.txt", "r")
lines = file.readlines

area = []

i = 0
j = 0
for line in lines
    area.push(line.strip.chars)
end

def deepCopy(arr)
    return arr.map{|x| x.clone}
end

def isOccupiedDirection(x, y, dirx, diry, area, maxDist)
    dist = 0
    while dist < maxDist
        x += dirx
        y += diry

        if x < 0 or y < 0 or x > area.length-1 or y > area[x].length-1
            break
        end

        if area[x][y] == "#"
            return true
        end
        if area[x][y] == "L"
            return false
        end

        dist += 1
    end
    return false
end

def adjacentOccupied(x, y, area, maxDist = 1)
    cnt = 0

    for i in -1..1
        for j in -1..1
            if i == 0 and j == 0
                next
            end
            if isOccupiedDirection(x, y, i, j, area, maxDist)
                cnt += 1
            end
        end
    end

    return cnt
end

def run(area, maxDist, maxOccup)
    seatsOcc = 0
    while true
        area_copy = deepCopy(area)
        for i in 0..area_copy.length-1
            for j in 0..area_copy[i].length-1
                sp = area[i][j]
                if sp == "L" and adjacentOccupied(i, j, area, maxDist) == 0
                    area_copy[i][j] = "#"
                elsif sp == "#" and adjacentOccupied(i, j, area, maxDist) >= maxOccup
                    area_copy[i][j] = "L"
                end
            end
        end

        sc = area_copy.map{|line| line.count("#")}.sum
        if sc == seatsOcc
            break
        end

        seatsOcc = sc
        area = deepCopy(area_copy)
    end

    puts seatsOcc
end

run(area, 1, 4) # part 1
run(area, 9999, 5) # part 2