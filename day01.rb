
def part_1(numbers)
  for i in 0..numbers.length-1
    for j in i..numbers.length-1
      n1 = numbers[i]
      n2 = numbers[j]
      if n1 + n2 == 2020
        puts "#{n1}, #{n2}, #{n1 * n2}"
      end
    end
  end
end

def part_2(numbers)
  for i in 0..numbers.length-1
    for j in i..numbers.length-1
      for k in j..numbers.length-1
        n1 = numbers[i]
        n2 = numbers[j]
        n3 = numbers[k]
        if n1 + n2 + n3 == 2020
          puts "#{n1}, #{n2}, #{n3}, #{n1 * n2 * n3}"
        end
      end
    end
  end
end

file = File.open("input/day01.txt", "r")
numbers = file.readlines.map {|line| line.to_i }

part_1(numbers)
part_2(numbers)