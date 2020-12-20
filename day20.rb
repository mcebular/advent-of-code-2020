
class Position
    def initialize(x, y)
        @x = x
        @y = y
    end

    def neighbours()
        positions = []
        for i in [-1, 0, +1]
            for j in [-1, 0, +1]
                if i == j and j == 0
                    next
                end
                positions.push(Position.new(@x + i, @y + j, @z + k, @w + l))
            end
        end
        return positions
    end

    def direction()
        if @x == 0 and @y == +1
            return :top
        elsif @x == 0 and @y == -1
            return :bottom
        elsif @x == +1 and @y == 0
            return :right
        elsif @x == -1 and @y == 0
            return :left
        else
            throw "achoo!"
        end
    end

    def x
        @x
    end

    def y
        @y
    end

    def +(other)
        return Position.new(self.x + other.x, self.y + other.y)
    end

    def ==(other)
        return (@x == other.x and @y == other.y)
    end

    alias eql? ==

    def hash
        @x.hash ^ @y.hash
    end

    def to_s()
        return "Pos<x=#{@x} y=#{@y}>"
    end
end

def rotate_array(arr2d, times)
    while times > 0
        arr2d = arr2d.reverse.transpose # clockwise rotation
        times -= 1
    end
    return arr2d
end

def flip_array(arr2d, dir)
    case dir
    when :hor
        return arr2d.reverse
    when :ver
        return arr2d.map{|l| l.reverse}
    when nil
        return arr2d
    else
        throw "Invalid dir for flip: #{dir}."
    end
end

class Tile
    def initialize(id, tile)
        @id = id
        @tile = tile
    end

    def to_s
        return "Tile<id=#{@id}>"
    end

    def id
        @id
    end

    def tile
        @tile
    end

    def tile=(tile)
        @tile = tile
    end

    def border(dir)
        case dir
        when :top
            return @tile[0].join("")
        when :bottom
            return @tile[-1].join("")
        when :left
            return @tile.map{|l| l[0]}.join("")
        when :right
            return @tile.map{|l| l[-1]}.join("")
        else
            throw "Invalid dir for border: #{dir}."
        end
    end

    def rotate(times)
        rt = self.clone()
        rt.tile = rotate_array(rt.tile, times)
        return rt
    end

    def flip(dir)
        ft = self.clone()
        ft.tile = flip_array(ft.tile, dir)
        return ft
    end

    def clone()
        return Tile.new(id, Array.new(tile.map{|x| Array.new(x)}))
    end

    def anySameBorder(other, dir)
        # returns other tile if rotated/flipped other tile shares the same border, nil otherwise
        for other_rot in 0..3
            for other_flip in [nil, :hor, :ver]
                mod_other = other.rotate(other_rot).flip(other_flip)
                if dir == :right and self.border(:right) == mod_other.border(:left)
                    return mod_other

                elsif dir == :bottom and self.border(:bottom) == mod_other.border(:top)
                    return mod_other

                elsif dir == :left and self.border(:left) == mod_other.border(:right)
                    return mod_other

                elsif dir == :top and self.border(:top) == mod_other.border(:bottom)
                    return mod_other

                end
            end
        end

        return nil
    end
end


file = File.open("input/day20.txt", "r")
lines = file.readlines
tiles = []

id = nil
tile = []
for line in lines
    if line.start_with?("Tile")
        if id != nil
            tiles.push(Tile.new(id, tile))
        end
        id = line.split(" ")[1][0..-2].to_i
        tile = []
    elsif line.strip != ""
        tile.push(line.strip.chars)
    end
end
tiles.push(Tile.new(id, tile))


def find_matching(tile, tiles, dir)
    for other in tiles
        mod_other = tile.anySameBorder(other, dir)
        if mod_other != nil
            return mod_other
        end
    end
    return nil
end


sea = {}
sea[Position.new(0, 0)] = tiles.shift()

while tiles.length > 0
    # iterate all tiles of currently known sea and try to find neighbours
    for c_pos, c_tile in sea.clone
        for n_pos in [Position.new(0, +1), Position.new(+1, 0), Position.new(0, -1), Position.new(-1, 0)]
            m_tile = find_matching(c_tile, tiles, n_pos.direction)
            if m_tile != nil
                tiles.delete_if{|x| x.id == m_tile.id}
                sea[c_pos + n_pos] = m_tile
            end
        end
    end
end

# sea.each{|k, v| puts "#{k} #{v.id}"}

min_x = sea.keys.map{|p| p.x}.min
min_y = sea.keys.map{|p| p.y}.min
max_x = sea.keys.map{|p| p.x}.max
max_y = sea.keys.map{|p| p.y}.max

topLeft = sea[Position.new(min_x, min_y)]
topRight = sea[Position.new(max_x, min_y)]
bottomLeft = sea[Position.new(min_x, max_y)]
bottomRight = sea[Position.new(max_x, max_y)]

# part 1
puts topLeft.id * topRight.id * bottomLeft.id * bottomRight.id


def clip_border(arr2d)
    return arr2d[1..-2].map{|a| a[1..-2]}
end

# tile size when border removed:
tile_size = clip_border(topLeft.tile).length

# allocate 2d array for our sea!
width = max_x - min_x + 1
height = max_y - min_y + 1

sea2 = []
for pos, tile in sea
    x = (pos.x + min_x.abs) * tile_size
    y = (pos.y + min_y.abs) * tile_size
    ct = clip_border(tile.flip(:hor).tile)
    for i in 0..tile_size-1
        for j in 0..tile_size-1
            if sea2[y + i] == nil
                sea2[y + i] = []
            end
            sea2[y + i][x + j] = ct[i][j]
        end
    end
end

$MONSTER = [
    Position.new(0, 1),
    Position.new(1, 2),
    Position.new(4, 2),
    Position.new(5, 1),
    Position.new(6, 1),
    Position.new(7, 2),
    Position.new(10, 2),
    Position.new(11, 1),
    Position.new(12, 1),
    Position.new(13, 2),
    Position.new(16, 2),
    Position.new(17, 1),
    Position.new(18, 0),
    Position.new(18, 1),
    Position.new(19, 1),
]

def is_sea_monster?(sub_sea)
    if sub_sea == nil
        return
    end
    for pos in $MONSTER
        if sub_sea[pos.y] == nil or sub_sea[pos.y][pos.x] != "#"
            return false # no monster here!
        end
    end
    return true
end


for sea_rot in 0..3
    for sea_flip in [nil, :hor, :ver]
        sea2 = rotate_array(flip_array(sea2, sea_flip), 1)
        for i in 0..sea2.length-1
            for j in 0..sea2[i].length-1
                if is_sea_monster?(sea2[j..j+2].map{|x| x[i..i+19]})
                    for pos in $MONSTER
                        sea2[j + pos.y][i + pos.x] = "O"
                    end
                end
            end
        end
    end
end

# puts sea2.map{|a| a != nil ? a.join("") : ""}.join("\n")
# part 2
puts sea2.sum{|a| a.count{|b| b == "#"}}