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

    def my_select(&block)
      if block_given?
        result = []
        my_each { |n| result << n if block.call(n) }
        result
      else
        self.to_enum(__method__)
      end
    end

    def my_tally(h = {})
      h.default = 0
      my_each { |n| h[n] += 1 }

      h
    end

    def my_uniq(&block)
      result = []
      hash = {}
      # my_each { |n| result << n unless result.include?(n) }
      my_each do |n|
        x = block_given? ? block.call(n) : n
        unless hash[x]
          hash[x] = true
          result << n
        end
      end
      result
    end

    def my_each_cons(n, &block)
      return self.to_enum(:each_cons, n) unless block_given?

      result = []

      (size - n + 1).times do |i|
        result << self[i, n]
      end

      result.my_each do |ary|
        block.call(ary)
      end

      self
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
# p [1, 2, 3, 4, 5].my_select{ |n| n.even? }
# hash = {}
# p [:a, :b, :c, :b, :a, :a, :a].my_tally == {a: 4, b: 2, c: 1}
# p [:a, :b, :c, :b, :a, :a, :a].my_tally(hash) == {a: 4, b: 2, c: 1}
# p [:a, :b, :c, :b, :a, :a, :a].my_tally(hash) == {a: 8, b: 4, c: 2}

p [:a, :b, :c, :b, :a, :a, :a].my_uniq == [:a, :b, :c]
p [*1..100].my_uniq{|x| (x**2) % 10 } == [1, 2, 3, 4, 5, 10]
p [*1..10].my_each_cons(3) {|v| v } == [*1..10].each_cons(3) { |v| v }
p [*1..5].my_each_cons(3)
p [*1..5].my_each_cons(3).to_a == [[1, 2, 3], [2, 3, 4], [3, 4, 5]]
# 変換前　　変換後
# 1     % 2 = 1
# 2     % 2 = 0
# --------------
# 3     % 2 = 1
# 4     % 2 = 0

# => 1, 0  違う
# => 1, 2 返したいもの
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

-- 次回以降の候補 --
- group_by
- cycle
- find_index
- rotate
- all?
