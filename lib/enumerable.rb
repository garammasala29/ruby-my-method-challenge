using(Module.new do
  refine Array do
    def my_each(&block)
      if block_given?
        new_array = self.dup
        while result = new_array.shift
          block.call(result)
        end
        self
      else
        self.to_enum
      end
    end

    def my_map(&block)
      return to_enum if !block_given?

      new_array = []
      copy_array = dup
      new_array << my_each { |n| block.call(n) }
    end

    def my_sum(init = 0, &block)
      result = init
      if block_given?
        my_each { |n| result += block.call(n) }
      else
        my_each { |n| result += n }
      end
      result
    end

    def my_sort
      new_array = []

      new_array
    end

    def my_min
      min = Float::INFINITY

      my_each { |n| min = n if n < min }

      min
    end
  end
end)

# p [1, 2, 3].my_each { puts _1 * 3 }
# p [1, 2, 3].my_map { |n| n * 10 }
# p [1, 2, 3].my_map(&:succ)
# p [1, 2, 3].my_map

# p [1, 2, 3.0].my_sum.eql?(6.0)
# p [1, 2, 3].my_sum { |n| n * 10 } == 60
# p [1, 2, 3].my_sum(3) == 9
# p [1, 2, 3].my_sum(3, &:succ) == 12
# p [*'a'..'c'].my_sum('') == 'abc'
# p [*'a'..'c'].my_sum('', &:succ) == 'bcd'

[4, 2, 3].my_sort == [2, 3, 4]
['b', 'd', 'a'].my_sort == ['a', 'b', 'd']
p [4, 2, 3].my_min == 2

__END__
my_sum
-[] 復習

my_min
-[] ブロックをとった時の実装
[1, 2, 3].min { |a, b| a <=> b}
1 <=> 2 # => -1
2 <=> 3 # => -1

[1, 2, 3].min { |a,b| b <=> a }
2 <=> 1 #=> 1
3 <=> 2 #=> 1

-[] 引数をとった時の実装

my_sort
