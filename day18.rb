
def end_paranthesis_index(str)
    i = 0
    nesting = 0
    while i < str.length
        c = str[i]

        if c == "("
            nesting += 1
        elsif c == ")"
            nesting -= 1
            if nesting == 0
                return i
            end
        end

        i += 1
    end

    throw "No ending paranthesis for " + str
end

def parse_expr(expr, eval_func)
    # puts expr.join("")

    tokens = []
    i = 0
    tok = ""

    while i <= expr.length-1
        c = expr[i]

        if c == "+" || c == "*"
            tokens.push(tok.to_i)
            tokens.push(c)
            tok = ""
        elsif c == "("
            epi = end_paranthesis_index(expr[i..expr.length])
            tok = eval_func.call(parse_expr(expr[i+1..i+epi-1], eval_func))
            i = i+epi
        else
            tok += c
        end

        i += 1
    end

    tokens.push(tok.to_i)
    return tokens
end

def eval_expr1(tokens)
    tokens = Array.new(tokens)
    t1 = tokens.shift()
    while tokens.length > 0
        op = tokens.shift()
        t2 = tokens.shift()
        if op == "+"
            t1 = t1 + t2
        elsif op == "*"
            t1 = t1 * t2
        end
    end
    return t1
end

def eval_expr2(tokens)
    if (tokens.length == 3)
        return eval_expr1(tokens)
    end

    tokens = Array.new(tokens)
    t1 = tokens.shift()
    op = tokens.shift()
    t2 = tokens.shift()
    op2 = tokens.shift()
    t3 = tokens.shift()

    if op == "+"
        return eval_expr2([eval_expr2([t1, op, t2])] + [op2, t3] + tokens)
    elsif op == "*"
        return eval_expr2([t1, op] + [eval_expr2([t2, op2, t3] + tokens)])
    end
end

file = File.open("input/day18.txt", "r")
lines = file.readlines


sum1 = 0
sum2 = 0
for line in lines
    line = line.strip.chars.filter{|x| x != " "}.join("")

    tokens1 = parse_expr(line, method(:eval_expr1))
    sum1 += eval_expr1(tokens1)

    tokens2 = parse_expr(line, method(:eval_expr2))
    sum2 += eval_expr2(tokens2)
end

puts sum1, sum2