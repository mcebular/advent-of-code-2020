require 'set'

file = File.open("input/day22.txt", "r")
lines = file.readlines

decks = {}
decks[1] = []
decks[2] = []

player = 0
for line in lines
    if line.start_with?("Player 1:")
        player = 1
        next
    elsif line.start_with?("Player 2:")
        player = 2
        next
    end

    if line.strip == ""
        next
    end

    decks[player].push(line.strip.to_i)
end

def combat(deck1, deck2)
    while deck1.length > 0 and deck2.length > 0

        p1c = deck1.shift
        p2c = deck2.shift

        if p1c > p2c
            deck1.push(p1c)
            deck1.push(p2c)
        elsif p2c > p1c
            deck2.push(p2c)
            deck2.push(p1c)
        end

    end

    if deck2.length == 0
        return 1, deck1
    else
        return 2, deck2
    end
end

def deck_score(deck)
    return deck.reverse.each_with_index.map{|card, index| card * (index + 1)}.sum
end

winning_player, winning_deck = combat(Array.new(decks[1]), Array.new(decks[2]))
puts deck_score(winning_deck) # part 1

def recursive_combat(deck1, deck2)
    round = 1
    saved_decks = Set[]
    while deck1.length > 0 and deck2.length > 0
        # puts "Round #{round}, deck 1: #{deck1}, deck 2: #{deck2}"
        round += 1
        tmp = deck1.to_s + deck2.to_s
        if saved_decks.include?(tmp)
            # automatic win for player 1
            # puts "Already seen, win to player 1!"
            return 1, deck1
        end

        saved_decks.add(tmp)

        p1c = deck1.shift
        p2c = deck2.shift

        winner = 1
        if p1c <= deck1.length and p2c <= deck2.length
            # puts "Sub-game started..."
            winner, win_deck = recursive_combat(deck1[0..p1c-1], deck2[0..p2c-1])
        else
            winner = p1c > p2c ? 1 : 2
        end

        if winner == 1
            deck1.push(p1c)
            deck1.push(p2c)
        else # winner == 2
            deck2.push(p2c)
            deck2.push(p1c)
        end
    end

    if deck1.length > deck2.length
        return 1, deck1
    else
        return 2, deck2
    end
end

winning_player, winning_deck = recursive_combat(Array.new(decks[1]), Array.new(decks[2]))
puts deck_score(winning_deck) # part 2