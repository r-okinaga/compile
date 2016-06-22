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

class Type < Expression
    attr_accessor :name, :expr

    def initialize(name, expr)
        @name = name
        @expr = expr
    end
end

class Int < Type
end

class Str < Type
end

class Variable < Expression
    attr_accessor :name

    def initialize(name)
        @name = name
    end
end

class CharStr < Expression
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
                when @scanner.scan(/\+|\-|\*|\/|\(|\)|[0-9]+|[a-z]+|=|"[^"]*"/)
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
        statement
    end

    def statement
        case token
            when 'int'
                shift
                v = shift
                unless v =~ /[a-z]/
                    raise 'alphabet Expected'
                end

                unless token == '='
                    raise '= Expected'
                end
                shift
                Int.new(v, expr)
            when 'str'
                shift
                v = shift
                unless v =~ /[a-z]/
                    raise 'alphabet Expected'
                end

                unless token == '='
                    raise '= Expected'
                end

                shift
                s = Str.new(v, expr)
            else
                expr
        end
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
        case token
            when /^[0-9]+/
                v = Value.new(shift.to_i)
            when '('
                shift
                v = expr
                unless token == ')'
                    raise ') Expected'
                end
                shift
            when /^[a-z]/
                v = Variable.new(shift)

            when /^"[^"]*"/
                v = Value.new(shift[1 .. -2])
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
        @env = {}
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
                expr.value
#            when CharStr
#                expr.value.to_s
            when Int
                @env[expr.name] = execute(expr.expr)
            when Str
                @env[expr.name] = execute(expr.expr)
            when Variable
                @env[expr.name]
            else
                raise 'Unknown Expression'
        end
    end
end

vm = VirtualMachine.new
#p Parser.new("str a = \"aaa\"").parse
#p Tokenizer.new("str a = \"aaa\"").tokenize

while true
    expr = gets.chomp
    break if expr =~ /q/i
    parsed = Parser.new(expr).parse
    p vm.execute(parsed)
end
