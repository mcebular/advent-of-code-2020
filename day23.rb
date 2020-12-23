require 'set'


class Cup
    def initialize(id)
        @id = id
        @next = nil
        @prev = nil
    end

    def id
        @id
    end

    def next
        @next
    end

    def pref
        @prev
    end

    def next=(cup)
        @next = cup
    end

    def prev=(cup)
        @prev = cup
    end

    def to_s
        return "#{@prev != nil ? @prev.id : "nil"} -> #{@id} -> #{@next != nil ? @next.id : "nil"}"
    end

    def to_i
        return @id
    end
end


# file = File.open("input/day23.txt", "r")
# lines = file.readlines

# input = "389125467" # example input
input = "598162734" # my input
do_part_2 = true

cups = input.chars.map{|x| Cup.new(x.to_i)}
if do_part_2
    for i in 10..1_000_000
        cups.push(Cup.new(i))
    end
end

cup_links = {}
for i in 0..cups.length-1
    cups[i].next = cups[(i+1)%cups.length]
    cups[i].prev = cups[i-1]
    cup_links[cups[i].id] = cups[i]
end
# cups.each{|c| puts c.to_s}
# exit

curr_cup = cups[0]
rounds = do_part_2 ? 10_000_000 : 100
while rounds > 0
    if do_part_2 && rounds % 1_000_000 == 0
        puts "Round #{rounds}"
    end

    # puts "Current cup: #{curr_cup.id}"
    take_out = curr_cup.next
    take_out_s = take_out
    take_out_e = take_out.next.next
    # break links for picked up cups
    curr_cup.next = take_out_e.next
    take_out_e.next.prev = curr_cup
    take_out_s.prev = nil
    take_out_e.next = nil

    # cups.each{|c| puts c.to_s}
    # puts "---"

    # find destination cup
    dest_cup = nil
    target_val = curr_cup.id - 1
    while target_val == 0 or target_val == take_out.id or target_val == take_out.next.id or target_val == take_out.next.next.id
        if target_val <= 0
            target_val = do_part_2 ? 1_000_000 : 9
            next
        else
            target_val -= 1
        end
    end

    dest_cup = cup_links[target_val]
    if dest_cup == nil
        throw "Target val doesn't exist? #{target_val}"
    end

    # puts "Destination cup: #{dest_cup.id}"

    # put picked up cups next to destination cup
    dest_cup.next.prev = take_out.next.next
    take_out.next.next.next = dest_cup.next
    dest_cup.next = take_out
    take_out.prev = dest_cup

    curr_cup = curr_cup.next

    rounds -= 1
end

if do_part_2
    c1 = cup_links[1].next.to_i
    c2 = cup_links[1].next.next.to_i

    puts c1, c2, c1 * c2
else
    print_cup = cup_links[1].next
    tmps = ""
    while print_cup.id != 1
        tmps += print_cup.id.to_s
        print_cup = print_cup.next
    end
    puts tmps
end