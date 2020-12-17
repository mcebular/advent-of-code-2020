require 'set'

file = File.open("input/day17.txt", "r")
lines = file.readlines

class Position
    def initialize(x, y, z, w)
        @x = x
        @y = y
        @z = z
        @w = w
    end

    def neighbours3d()
        positions = []
        for i in [-1, 0, +1]
            for j in [-1, 0, +1]
                for k in [-1, 0, +1]
                    if i == j and j == k and k == 0
                        next
                    end
                    positions.push(Position.new(@x + i, @y + j, @z + k, @w))
                end
            end
        end
        return positions
    end

    def activeNeighbours3dCount(space)
        return self.neighbours3d().map{|pos| space[pos]}.count("#")
    end

    def neighbours()
        positions = []
        for i in [-1, 0, +1]
            for j in [-1, 0, +1]
                for k in [-1, 0, +1]
                    for l in [-1, 0, +1]
                        if i == j and j == k and k == l and l == 0
                            next
                        end
                        positions.push(Position.new(@x + i, @y + j, @z + k, @w + l))
                    end
                end
            end
        end
        return positions
    end

    def activeNeighboursCount(space)
        return self.neighbours().map{|pos| space[pos]}.count("#")
    end

    def x
        @x
    end

    def y
        @y
    end

    def z
        @z
    end

    def w
        @w
    end

    def ==(other)
        return (@x == other.x and @y == other.y and @z == other.z and @w == other.w)
    end

    alias eql? ==

    def hash
        @x.hash ^ @y.hash ^ @z.hash ^ @w.hash
    end

    def to_s()
        return "<x=#{@x} y=#{@y} z=#{@z} w=#{@w}>"
    end
end

state = {}
state.default = "."
for i in 0..lines.length-1
    chars = lines[i].strip.chars
    for j in 0..chars.length-1
        state[Position.new(i, j, 0, 0)] = chars[j]
    end
end

rounds = 0
prev_state = state
while rounds < 6
    new_state = {}
    new_state.default = "."
    for position, state in prev_state
        # puts position, state

        # rule 1
        activeNeighbours = position.activeNeighboursCount(prev_state) # use 3d for part 1
        if state == "#" and (activeNeighbours == 2 or activeNeighbours == 3)
            new_state[position] = "#"
        end

        # rule 2
        for neighPosition in position.neighbours # use 3d for part 1
            activeNeighbours = neighPosition.activeNeighboursCount(prev_state) # use 3d for part 1
            if prev_state[neighPosition] == "." and (activeNeighbours == 3)
                new_state[neighPosition] = "#"
            end
        end
    end

    prev_state = new_state
    rounds += 1
    puts "Round ##{rounds} has #{prev_state.values.count("#")} active cubes."
end