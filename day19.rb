
def parseRule(str)
    rule = []
    rx = /([0-9]+): (.*)/
    md = rx.match(str)
    rule.push(md[1])

    if md[2][0] == "\""
        rule.push(md[2].strip()[1..-2])
    else
        rule.push(md[2].split(" "))
    end
end

def resolveRule(rules, ruleNo, accm, fixed_rules = {})
    if fixed_rules.has_key?(ruleNo)
        # puts "replacing #{ruleNo} with #{fixed_rules[ruleNo]}"
        return accm + fixed_rules[ruleNo]
    end

    rule = rules[ruleNo]
    # puts "Parsing #{ruleNo}: #{rule}"
    if rule == "a" or rule == "b"
        return accm + rule
    end

    split_index = -1
    for i in 0..rule.length-1
        if rule[i] == "|"
            split_index = i
        end
    end

    if split_index == -1
        return accm + rule.map{|rn| resolveRule(rules, rn, accm, fixed_rules)}.join("")
    else
        left = rule[0..split_index-1].map{|rn| resolveRule(rules, rn, accm, fixed_rules)}.join("")
        right = rule[split_index+1..-1].map{|rn| resolveRule(rules, rn, accm, fixed_rules)}.join("")
        return "(" + accm + left + "|" + accm + right + ")"
    end

end


file = File.open("input/day19.txt", "r")
lines = file.readlines

rules = {}
messages = []

isMessages = false
for line in lines
    if line.strip == ""
        isMessages = true
    end

    if not isMessages
        rule = parseRule(line)
        rules[rule[0]] = rule[1]
    else
        messages.push(line.strip())
    end
end

# puts rules
# puts messages

rule_rx = Regexp.new("^#{resolveRule(rules, "0", "")}$")
puts messages.count{|m| rule_rx.match?(m)}

rule42 = "#{resolveRule(rules, "42", "")}"
rule31 = "#{resolveRule(rules, "31", "")}"

fix_rules = {}
# 8 is just 42 repeated at least one time
fix_rules["8"] = "(#{rule42})+"
# 11 is repeated 42 42 42 ... 11 ... 31 31 31
# This is actually possible to do in regex, below is a slight modification of this stackoverflow answer:
# https://stackoverflow.com/a/3644267/2907620
fix_rules["11"] = "(?:(?:#{rule42})(?=(?:#{rule42})*(?<xd>\\k'xd'?+(?:#{rule31}))))+\\k'xd'"

puts "^#{resolveRule(rules, "0", "", fix_rules)}$"

# I went the regex way and I sincerely regret it, but the thing actually works, except that it doesn't work in ruby (It
# does not report the right amount of matches for the 2nd part). Weird, because I printed out the regex pattern and
# tested it on https://regex101.com/ where it worked correctly (correct amount of matches).
# So I printed out the final regex pattern of the actual input data and used it with the actual input messages on said
# website and got the correct result: 306.

# Does not work (correctly):
# puts messages.count{|m| rule_rx2.match?(m)}