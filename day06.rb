require "set"

def parseAnswerGroups(lines)
    groups = []
    group = []
    person = Set[]
    for line in lines
        if line.strip.empty?
            groups.push(group)
            group = []
            next
        end
        line.strip.chars.each {|c| person.add(c)}
        group.push(person)
        person = Set[]
    end
    return groups
end

file = File.open("input/day06.txt", "r")
lines = file.readlines.push("")
# add an empty line to readlines so the for loop will also add the very last
# group to the groups array when parsing

groups = parseAnswerGroups(lines)
puts groups.map {|group| group.reduce(:|)}.map {|x| x.length}.sum # part 1 (union)
puts groups.map {|group| group.reduce(:&)}.map {|x| x.length}.sum # part 2 (intersection)