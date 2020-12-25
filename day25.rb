
#file = File.open("input/day25.txt", "r")
#lines = file.readlines

$div_num = 20201227

# sample input
# card_public_key = 5764801
# door_public_key = 17807724
# actual input
card_public_key = 10705932
door_public_key = 12301431


def transform(subject_number, public_key, max_rounds = 0)
    tmp = 1
    rounds = 0
    while true
        rounds += 1

        tmp *= subject_number
        tmp = tmp % $div_num

        if tmp == public_key
            # puts "Card loop size: #{rounds}"
            return rounds, tmp
        end

        if max_rounds > 0 and rounds >= max_rounds
            return rounds, tmp
        end
    end
end

card_loop_size, _ = transform(7, card_public_key)
door_loop_size, _ = transform(7, door_public_key)

puts card_loop_size, door_loop_size

_, encryption_key = transform(door_public_key, nil, card_loop_size)
puts encryption_key