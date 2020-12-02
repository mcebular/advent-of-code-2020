class PwdEntry
    def initialize(letter, n1, n2, password)
        @letter = letter
        @n1 = n1
        @n2 = n2
        @password = password
    end

    def policy1_valid
        count = @password.chars.count{|c| c == @letter}
        return count >= @n1 && count <= @n2
    end

    def policy2_valid
        chars = @password.chars
        return chars[@n1 - 1] == @letter && chars[@n2 - 1] != @letter || chars[@n1 - 1] != @letter && chars[@n2 - 1] == @letter
    end
end

def parsePwdEntry(line)
    rx = /([0-9]+)-([0-9]+) ([a-z]): ([a-z]+)/
    md = rx.match(line)
    return PwdEntry.new(md[3], md[1].to_i, md[2].to_i, md[4])
end

file = File.open("input/day02.txt", "r")
pwds = file.readlines.map {|line| parsePwdEntry(line) }

puts pwds.count { |e| e.policy1_valid }
puts pwds.count { |e| e.policy2_valid }
