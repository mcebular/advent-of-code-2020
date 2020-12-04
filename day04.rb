
file = File.open("input/day04.txt", "r")
lines = file.readlines

$fieldNames = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"] # + "cid"

class Hash

    def hasAllFields
        for fn in $fieldNames
            if not has_key?(fn)
                return false
            end
        end
        return true
    end

    def isValidPassport
        if !hasAllFields
            return false
        end

        checks = 0

        checks += validNumber(self["byr"], 1920, 2002)
        checks += validNumber(self["iyr"], 2010, 2020)
        checks += validNumber(self["eyr"], 2020, 2030)

        if self["hgt"].match?(/([0-9]+)in/)
            md = self["hgt"].match(/([0-9]+)in/)
            checks += validNumber(md[1], 59, 76)
        elsif self["hgt"].match?(/([0-9]+)cm/)
            md = self["hgt"].match(/([0-9]+)cm/)
            checks += validNumber(md[1], 150, 193)
        end

        checks += validHex(self["hcl"])

        for ecl in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
            if self["ecl"] == ecl
                checks += 1
                break
            end
        end

        checks += (self["pid"].match?(/^[0-9]{9}$/) ? 1 : 0)

        return checks == 7
    end
end

def validNumber(value, min, max)
    if (value.to_i < min || value.to_i > max)
        return 0
    end
    return 1
end

def validHex(value)
    return value.match?(/#[0-9a-fA-F]{6}$/) ? 1 : 0
end

def processPassport(passport)
    # puts passport
    fields = {}
    passport.split(" ").map{|e| e.split(":")}.each {|e| fields[e[0]] = e[1]}

    return fields
    # return fields.hasAllFields # part 1
    return fields.isValidPassport
end

passports = []
passport = ""
for line in lines
    passport += " " + line.rstrip
    if line.strip.empty?
        passports.push(processPassport(passport))
        passport = ""
        next
    end
end
if !passport.strip.empty?
    passports.push(processPassport(passport))
end

puts passports.count # total
puts passports.count {|p| p.hasAllFields} # part 1
puts passports.count {|p| p.isValidPassport} # part 2