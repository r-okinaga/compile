class Expression
end

class BinOpe < Expression
    attr_accessor :l_expr, :r_expr

    def initialize(l_expr, r_expr)
        @l_expr = l_expr
        @r_expr = r_expr
    end
end

class Add < BinOpe
end

class Subtract < BinOpe
end

class Multiply < BinOpe
end

class Divide < BinOpe
end

class UnaOpe < Expression
end

class Minus < Expression
end

class Value < Expression
    attr_accessor :value

    def initialize(value)
        @value = value
    end
end

require 'strscan'

class Tokenizer
    def initialize(str)
        @scanner = StringScanner.new(str)
        @tokens = []
    end

    def tokenize
        while !@scanner.eos?
            case
                when @scanner.scan(/\+|\-|\*|\/|\(|\)|[0-9]+/)
                    @tokens << @scanner.matched
                when @scanner.scan(/[ ]+/)
                    #空白の時は何もしない
            end
        end
        @tokens
    end
end

class Parser
    def initialize(str)
        @tokens = Tokenizer.new(str).tokenize
    end

    def parse
        expr
    end

    def expr
        t = term
        while %w(+ -).include? token
            case token
                when '+'
                    shift
                    t = Add.new(t, term)
                when '-'
                    shift
                    t = Subtract.new(t, term)
            end
        end
        t
    end

    def term
        f = factor
        while %w(* /).include? token
            case token
                when '*'
                    shift
                    f = Multiply.new(f, factor)
                when '/'
                    shift
                    f = Divide.new(f, factor)
            end
        end
        f
    end

    def factor
        v = nil
        case token
            when /[0-9]+/
                v = Value.new(shift)
            when '('
                shift
                v = expr
                unless token == ')'
                    raise ') Expected'
                end
                shift
            else
                raise 'Unknown Token'
        end
        v
    end

    def token
        @tokens.first
    end

    def shift
        @tokens.shift
    end
end

class VirtualMachine
    def initialize

    end

    def execute(expr)
        case expr
            when Add
                execute(expr.l_expr) + execute(expr.r_expr)
            when Subtract
                execute(expr.l_expr) - execute(expr.r_expr)
            when Multiply
                execute(expr.l_expr) * execute(expr.r_expr)
            when Divide
                execute(expr.l_expr) / execute(expr.r_expr)
            when Value
                expr.value.to_i
        end
    end
end

vm = VirtualMachine.new
p vm.execute(Parser.new("(2+4)*5").parse)
