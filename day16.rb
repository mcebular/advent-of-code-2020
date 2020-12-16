require 'set'

file = File.open("input/day16.txt", "r")
lines = file.readlines

rules = []
my_ticket = []
tickets = []

pt = 0
for line in lines
    if line.strip == "nearby tickets:" or line.strip == "your ticket:"
        next
    end

    if line.strip == ""
        pt += 1
        next
    end

    if pt == 0
        rx = /([\w ]+): ([0-9]+)-([0-9]+) or ([0-9]+)-([0-9]+)/
        md = rx.match(line)
        rule = []
        rule.push(md[1])
        rule += md[2..5].map{|n| n.to_i}
        rules.push(rule)
        next
    end

    if pt == 1
        my_ticket = line.split(",").map{|n| n.to_i}
        next
    end

    if pt == 2
        tickets.push(line.split(",").map{|n| n.to_i})
        next
    end
end

# puts rules
# puts "--"
# puts tickets.map{|t| t.join(",")}

def fits(field, rule)
    min1 = rule[1]
    max1 = rule[2]
    min2 = rule[3]
    max2 = rule[4]
    if (field >= min1 and field <= max1) or (field >= min2 and field <= max2)
        return rule[0]
    end
    return nil
end

def fits_many(field, rules)
    for rule in rules
        t = fits(field, rule)
        if t != nil
            return t
        end
    end
    return nil
end

invalidNums = []
validTickets = [my_ticket]
for ticket in tickets
    invalid = false

    for field in ticket
        if fits_many(field, rules) == nil
           invalidNums.push(field)
           invalid = true
        end
    end

    if not invalid
        validTickets.push(ticket)
    end
end

puts invalidNums.sum # part 1


def fits_all(fields, rules)
    fitting = Set[]
    for rule in rules
        does_fit = fields.map{|f| fits(f, rule) != nil}
        if does_fit.all?(true)
            fitting.add(rule[0])
        end
    end
    return fitting
end

possible_rules = []
for field_index in 0..my_ticket.length-1
    fields = validTickets.map{|t| t[field_index]}
    rule_names = fits_all(fields, rules)
    possible_rules[field_index] = rule_names
end

rule_field_mapping = {}
while possible_rules.map{|x| x.to_a.count}.sum > 0
    for i in 0..possible_rules.length-1
        pr = possible_rules[i]

        if pr.length == 1
            rule = pr.to_a[0]
            for j in 0..possible_rules.length-1
                rule_field_mapping[i] = rule
                possible_rules[j] = possible_rules[j].delete(rule)
            end
            break
        end
    end
end

# puts rule_field_mapping
puts rule_field_mapping.filter{|k, v| v.start_with?("departure")}.keys.map{|i| my_ticket[i]}.reduce(1, :*)
