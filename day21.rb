require 'set'

file = File.open("input/day21.txt", "r")
lines = file.readlines

class Food
    def initialize(ingredients, allergens)
        @ingredients = ingredients.to_set
        @allergens = allergens.to_set
    end

    def ingredients
        @ingredients
    end

    def allergens
        @allergens
    end

end

foods = []
all_ingredients = Set[]
for line in lines
    ingr, allr = line.split("(contains")
    allr = allr.strip()[0..-2].split(", ").map{|x| x.strip()}
    foods.push(Food.new(ingr.split(" "), allr))
    ingr.split(" ").each do |i|
        all_ingredients.add(i.strip())
    end
end

ingr_allr_map = {}
# puts all_ingredients
for i in 0..foods.length-1
    for j in i+1..foods.length-1
        f1 = foods[i]
        f2 = foods[j]
        # do they share an allergen? If yes, add all shared ingredients to a list
        # of potentially containing any of shared allergens
        common_allr = f1.allergens & f2.allergens
        for a in common_allr
            common_ingr = f1.ingredients & f2.ingredients
            if ingr_allr_map[a] == nil
                ingr_allr_map[a] = common_ingr
            else
                ingr_allr_map[a] = ingr_allr_map[a] & common_ingr
            end
        end
    end
end

# some foods are left with exactly one ingredient and one allergen
for f in foods
    own_ingr = f.ingredients - ingr_allr_map.values.reduce(Set[]){ |memo, obj| memo | obj }
    own_allr = f.allergens - ingr_allr_map.keys.reduce(Set[]){ |memo, obj| memo | [obj] }
    if own_ingr.length == 1 and own_allr.length == 1
        ingr_allr_map[allr] = own_ingr
    end
end

# puts ingr_allr_map

# part 1
unknown_ingr = all_ingredients - (ingr_allr_map.values.reduce(Set[]){ |memo, obj| memo | obj })
puts foods.sum{|f| f.ingredients.filter{|i| unknown_ingr.include?(i)}.count}

# part 2
# smfz,vhkj,qzlmr,tvdvzd,lcb,lrqqqsg,dfzqlk,shp
# The set was actually small enough that it easy to do it by hand. But I did an
# implementation anyway (below)

# contains allr => ingr (not allr => Set[ingr])
final_ingr_allr_map = {}
while ingr_allr_map.length > 0
    ingr_allr_map.compact!

    for allr in ingr_allr_map.keys
        if ingr_allr_map[allr].length == 1
            # put the pair into the final list
            final_ingr = ingr_allr_map[allr].to_a[0]
            final_ingr_allr_map[allr] = final_ingr
            # remove ingredient from all other allergen's possibles
            for a in ingr_allr_map.keys
                ingr_allr_map[a] = ingr_allr_map[a] - [final_ingr]
            end
            ingr_allr_map[allr] = nil
            break
        end
    end
end

puts final_ingr_allr_map.keys.sort.map{|a| final_ingr_allr_map[a]}.join(",")
