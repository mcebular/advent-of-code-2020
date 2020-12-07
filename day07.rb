require "set"

file = File.open("input/day07.txt", "r")
lines = file.readlines

class ColorfulBag
    def initialize(name)
        @name = name
        @contains = {}
        @contained = {}
    end

    def putContains(name, amount)
        @contains[name] = amount
    end

    def putContained(name, amount)
        @contained[name] = amount
    end

    def contains
        @contains
    end

    def contained
        @contained
    end

    def countContains(bags)
        return 1 + @contains.map {|k, v| v.to_i * bags[k].countContains(bags)}.sum
    end
end

def cleanBagName(name)
    name = name.strip
    if name[name.length-1] == "."
        name = name[0..name.length-2]
    end
    if name[name.length-1] == "s"
        name = name[0..name.length-2]
    end
    return name
end

class Hash

    def getOrCreate(key)
        # key = bag name
        if self.has_key?(key)
            return self[key]
        else
            self[key] = ColorfulBag.new(key)
            return self[key]
        end
    end

end


bags = {}

for line in lines
    bagName, bagContains = line.split("contain")
    bagName = cleanBagName(bagName)
    currentBag = bags.getOrCreate(bagName)

    for bagConName in bagContains.split(",").map {|b| b.strip}
        bagConName = cleanBagName(bagConName)

        if bagConName == "no other bag"
            break
        end

        times, name = bagConName.split(" ", 2)
        currentBag.putContains(name, times)
        bags.getOrCreate(name).putContained(bagName, times)
    end
end

myBagName = "shiny gold bag"

holdableBags = Set[]
checkingBags = [myBagName]
while checkingBags.length > 0
    bag = bags[checkingBags.pop]
    for k, v in bag.contained
        holdableBags.add(k)
        checkingBags.push(k)
    end
end

puts holdableBags.count # part 1
puts bags[myBagName].countContains(bags)-1 # part 2