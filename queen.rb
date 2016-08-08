class Y
    attr_accessor :array
    def initialize(array)
        @array = array
    end

    def one_bubble
        f = 0
        l = @array.size - 1

        for m in f..l do
            for n in f..l do
                if @array[n] < @array[m]
                    tmp = @array[n]
                    @array[n] = @array[m]
                    @array[m] = tmp
                    return @array
                end
            end
        end
        p @array
    end
end

queens = []

[*(1..8)].each do |i|
    a = Hash.new "q_#{i.to_s}"
    a[:x] = i
    queens << a
end


y =  Y.new [1,2,3,4,5,6,7,8]

queens.each_with_index do |q, i|
    q[:y] = y.array[i]
end

p queens
