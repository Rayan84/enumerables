# my_each
range = Range.new(1, 50)
block = proc { |num| num < 4 }
array.my_each.is_a?(Enumerator) # must return true
my_each_result = []
range.my_each { |item| my_each_result << item * 2 }
range.my_each { |item| item > 6 } # 5..50  my_each when a block is given when self is a range returns the range itself
# after calling the given block
# once for each element in self
range.my_each(&block) # 5..50
print "#my_each result: #{my_each_result}\n"

# my_each_with_index
block = proc { |num| num > 4 }
range = 5..50
array.my_each_with_index.is_a?(Enumerator)
[4, 23, 58, 29, 10, 28, 34, 95, 2].my_each_with_index { |item, index| p [item, index] }
range.my_each_with_index(&block) # 5..50 my_each_with_index when a block is given when self is a
# range returns the range itself after calling the given block once for each element in self

# my_select
array.my_select.is_a?(Enumerator)
array.my_select
block = proc { |num| num < 4 }
range.my_select(&block)

# my_all?
[4, 2, 2, 3].my_all? is_a? Enumerator # true
[1, 2, 3, 4, 5].my_all?(&:positive?) # true
[1, 2, 3, 4, 5].my_all?(&:negative?) # false
[1, 2, 3, 4, 5].my_all?(Numeric) # true
%w[duck deer dog birds].my_all?(/d/) # true
%w[duck deer dog birds].my_all?(/g/) # false
(5..50).my_all?(/5/) # false

# my_any
false_block = proc { |num| num > 9 }
true_array = [1, true, 'hi', []]
true_array.my_any?
range.my_any?(&false_block)
array.my_any? { |n| n > 3 }
array.my_any? { |n| n > 100 }

# my_none
true_array = [1, true, 'hi', []]
array = [1, 5, 5, 1, 3, 5, 1, 3, 2, 8, 5, 6, 3, 2, 2, 2, 5, 5]
[1, 2, 3, 4, 5].my_none?(Numeric) # false
true_array.my_none?
range.my_none?(&false_block)
array.my_none?(String)
%w[dog cat monkey].my_none?(/d/) # false
%w[bear cat monkey].my_none?(/d/) #true
ary = [1, 2, 4, 2]

# count
ary.count
ary.count(2)
ary.my_count
ary.my_count(2)

p([1, 2, 3].map { |n| n * 3 })
p([1, 2, 3].my_map { |n| n * 3 })
block = proc { |num| num < 4 }
range.my_map(&block)

p([2, 3, 4, 5].inject { |result, item| result + item })
p([2, 3, 4, 5].inject(0) { |result, item| result + item**2 })

p([2, 3, 4, 5].my_inject { |result, item| result + item })
p([2, 3, 4, 5].my_inject(0) { |result, item| result + item**2 })

def multiply_els(array)
  array.my_inject { |result, item| result * item }
end

multiply_els([2, 4, 5])
my_proc = proc { |n| n * 3 }

p [1, 2, 3].my_map my_proc
p([1, 2, 3].my_map { |n| n * 3 })
p [1, 2, 3].my_map { |n| n * 3 }.my_map my_proc
