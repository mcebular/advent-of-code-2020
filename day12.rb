
class Position
    def initialize(x, y)
        @pos = [x, y]
    end

    def x
        return @pos[0]
    end

    def y
        return @pos[1]
    end

    def x= (nx)
        @pos[0] = nx
    end

    def y= (ny)
        @pos[1] = ny
    end

    def rotate!(degrees)
        # rotate around origin
        rad = -degrees * 3.14 / 180
        s = Math.sin(rad)
        c = Math.cos(rad)
        nx = self.x * c - self.y * s
        ny = self.x * s + self.y * c
        self.x = nx.round
        self.y = ny.round
    end

    def manhattan
       self.x.abs + self.y.abs
    end

    def to_s
        return "x=#{self.x.abs}, y=#{self.y.abs}"
    end
end

file = File.open("input/day12.txt", "r")
lines = file.readlines

def parseInstruction(str)
    return [str[0], str[1..].to_i]
end

instructions = lines.map{|l| parseInstruction(l)}

currentPos = Position.new(0, 0) #[N/S, E/W]
direction = Position.new(0, +1)
for instr in instructions
    case instr[0]
    when "N"
        currentPos.x += instr[1]
    when "S"
        currentPos.x -= instr[1]
    when "E"
        currentPos.y += instr[1]
    when "W"
        currentPos.y -= instr[1]
    when "L"
        direction.rotate!(+instr[1])
    when "R"
        direction.rotate!(-instr[1])
    when "F"
        currentPos.x += direction.x * instr[1]
        currentPos.y += direction.y * instr[1]
    else
        puts "Invalid instruction: #{instr[0]}"
        break
    end
end

puts currentPos
puts currentPos.manhattan # part 1


currentPos = Position.new(0, 0)
waypointPos = Position.new(+1, +10)

for instr in instructions
    case instr[0]
    when "N"
        waypointPos.x += instr[1]
    when "S"
        waypointPos.x -= instr[1]
    when "E"
        waypointPos.y += instr[1]
    when "W"
        waypointPos.y -= instr[1]
    when "L"
        waypointPos.rotate!(instr[1])
    when "R"
        waypointPos.rotate!(-instr[1])
    when "F"
        currentPos.x = currentPos.x + (waypointPos.x * instr[1])
        currentPos.y = currentPos.y + (waypointPos.y * instr[1])
    else
        puts "Invalid instruction: #{instr[0]}"
        break
    end
end

puts currentPos
puts currentPos.manhattan # part 2
