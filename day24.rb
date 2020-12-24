require 'set'

class Position
    def initialize(x, y, z)
        @x = x
        @y = y
        @z = z
    end

    def x
        @x
    end

    def x=(nx)
        @x = nx
    end

    def y
        @y
    end

    def y=(ny)
        @y = ny
    end

    def z
        @z
    end

    def z=(nz)
        @z = nz
    end

    def neighbours()
        positions = []
        positions.push(Position.new(@x + 1, @y - 1, @z    ))
        positions.push(Position.new(@x    , @y - 1, @z + 1))
        positions.push(Position.new(@x - 1, @y    , @z + 1))
        positions.push(Position.new(@x - 1, @y + 1, @z    ))
        positions.push(Position.new(@x    , @y + 1, @z - 1))
        positions.push(Position.new(@x + 1, @y    , @z - 1))
        return positions
    end

    def ==(other)
        return (@x == other.x and @y == other.y and @z == other.z)
    end

    alias eql? ==

    def hash
        @x.hash ^ @y.hash ^ @z.hash
    end

    def to_s()
        return "Pos<x=#{@x} y=#{@y} z=#{@z}>"
    end
end

file = File.open("input/day24.txt", "r")
lines = file.readlines

# e = x+1, y-1
# se = y-1, z+1
# sw = x-1, z+1
# w = x-1, y+1
# nw = y+1, z-1
# ne = x+1, z-1

tiles = {}
for line in lines
    instr = line.strip.chars

    position = Position.new(0, 0, 0)
    while instr.length > 0
        i = instr.shift()
        if i == "s" or i == "n"
            i = i + instr.shift()
        end

        case i
        when "e"
            position.x += 1
            position.y -= 1
        when "se"
            position.y -= 1
            position.z += 1
        when "sw"
            position.x -= 1
            position.z += 1
        when "w"
            position.x -= 1
            position.y += 1
        when "nw"
            position.y += 1
            position.z -= 1
        when "ne"
            position.x += 1
            position.z -= 1
        else
            throw error "Invalid direction '#{i}'"
        end

        # puts i
    end

    if tiles.has_key?(position) and tiles[position] == :black
        tiles[position] = :white
    else
        tiles[position] = :black
    end
end

puts tiles.values.count{|t| t == :black}

def live_exhibit(tiles)
    new_tiles = {}
    tiles.filter{|k, v| v == :black}.each{|k, v| new_tiles[k] = v}

    for k, v in tiles
        for pos in [k] + k.neighbours
            neigh_colors = pos.neighbours.map{|x| tiles[x]}
            neigh_black = neigh_colors.count{|t| t == :black}
            neigh_white = neigh_colors.length - neigh_black

            curr_col = tiles[pos]
            if curr_col == :black and (neigh_black == 0 or neigh_black > 2)
                new_tiles[pos] = :white
            elsif (curr_col == :white or curr_col == nil) and (neigh_black == 2)
                new_tiles[pos] = :black
            end
        end
    end

    return new_tiles
end

for r in 0..99
    tiles = live_exhibit(tiles)
end
puts tiles.values.count{|t| t == :black}