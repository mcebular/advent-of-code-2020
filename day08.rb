require "set"

class GameConsole
    def initialize
        self.reset()
    end

    def reset
        @accumulator = 0
        @programPointer = 0
        @visitedPositions = Set[]
        @forceTerminated = false
    end

    def accumulator
        @accumulator
    end

    def run(program)
        # returns false if the program has been "forcefully" terminated (inf. loop)
        while true
            if (@visitedPositions.include?(@programPointer))
                @forceTerminated = true
                break
            end

            if @programPointer >= program.length
                # end of program
                @forceTerminated = false
                break
            end

            @visitedPositions.add(@programPointer)
            op, val = program[@programPointer].split(" ")
            case op
            when "nop"
                @programPointer += 1
                next
            when "acc"
                @programPointer += 1
                @accumulator += val.to_i
                next
            when "jmp"
                @programPointer += val.to_i
                next
            else
                puts "Invalid operation: #{op}"
                break
            end
        end

        return !@forceTerminated
    end
end

file = File.open("input/day08.txt", "r")
program = file.readlines

gc = GameConsole.new()
gc.run(program)
puts gc.accumulator # part 1
gc.reset()

for i in 0..program.length-1
    # just try to fix each operation until program doesn't forcefully terminate
    # due to an infinite loop
    op, val = program[i].split(" ")
    program_copy = Array.new(program)
    if op == "nop"
        program_copy[i] = "jmp #{val}"
    elsif op == "jmp"
        program_copy[i] = "nop #{val}"
    else
        next
    end

    ok = gc.run(program_copy)
    if ok
        puts gc.accumulator # part 2
    end
    gc.reset()
end