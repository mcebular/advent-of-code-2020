
file = File.open("input/day15.txt", "r")
numbers = file.readlines[0].split(",").map{|x| x.to_i}

class Hash

    def getOrInit(key)
        # if number is not defined, initialize an array for it
        if self.has_key?(key)
            return self[key]
        else
            self[key] = []
            return self[key]
        end
    end

end

currentRound = 0
prevNumber = ""
lastTimeSpoken = {}

while true

    if currentRound < numbers.length
        currentNumber = numbers[currentRound]
        lastTimeSpoken.getOrInit(currentNumber).push(currentRound)
        prevNumber = numbers[currentRound]
        currentRound += 1
        next
    end

    if lastTimeSpoken[prevNumber].length == 1
        currentNumber = 0
        lastTimeSpoken.getOrInit(0).push(currentRound)
    else
        lt1 = lastTimeSpoken[prevNumber][-1]
        lt2 = lastTimeSpoken[prevNumber][-2]
        currentNumber = lt1 - lt2
        lastTimeSpoken.getOrInit(currentNumber).push(currentRound)
    end

    prevNumber = currentNumber
    currentRound += 1

    if currentRound == 2020
        puts "Part 1: #{currentNumber}"
    end

    if currentRound == 30_000_000
        puts "Part 2: #{currentNumber}"
    end

    # print some progress
    #if currentRound % 1_000_000 == 0
    #    puts "Round: #{currentRound}, number: #{currentNumber}"
    #end

    if (currentRound > 30_000_000)
        break
    end

end