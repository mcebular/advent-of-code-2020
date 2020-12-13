
file = File.open("input/day13.txt", "r")
lines = file.readlines

departTime = lines[0].to_i
busIds = lines[1].split(",").filter{|x| x != "x"}.map{|x| x.to_i}
lineIds = lines[1].split(",").map{|x| x.strip}


minbt = [0, Float::INFINITY] # [busId, time]
for busId in busIds
    rounds = departTime / busId
    waitTime = ((rounds + 1) * busId) - departTime
    # puts "Bus #{busId} departed at #{(rounds + 1) * busId}. Waiting #{waitTime} minutes."
    if waitTime < minbt[1]
        minbt = [busId, waitTime]
    end
end

puts minbt[0] * minbt[1] # part 1

require_relative 'util/crt.rb'
puts chinese_remainder(busIds, busIds.map{|x| x - lineIds.find_index(x.to_s)}) # part 2