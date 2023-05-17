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
      # my_each{ |n| new_array << block.call(n) }
      # for n in self do
      #   new_array << block.call(n)
      # end
      copy_array = dup
      while result = copy_array.shift
        new_array << block.call(result)
      end

      new_array
    end
  end
end)

p [1, 2, 3].my_each { puts _1 * 3 }
p [1, 2, 3].my_map { |n| n * 10 }
p [1, 2, 3].my_map(&:succ)
p [1, 2, 3].my_map


