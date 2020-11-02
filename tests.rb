array = [1, 5, 5, 1, 3, 5, 1, 3, 2, 8, 5, 6, 3, 2]
true_array = [1, true, 'hi', []]
false_array = [1, false, 'hi', []]
block = proc { |num| num < 4 }
false_block = proc { |num| num > 9 }
range = Range.new(1, 50)

# my_each
array.my_each.is_a?(Enumerator)
my_each_result = []
array.my_each { |item| my_each_result << item * 2 }
range.my_each { |item| my_each_result << item * 2 }
print "#my_each result: #{my_each_result}\n"

# my_each_with_index
array.my_each_with_index.is_a?(Enumerator)
[4, 23, 58, 29, 10, 28, 34, 95, 2].my_each_with_index { |item, index| p [item, index] }
range = (5..50)
range.my_each_with_index(&block)

# my_select
array.my_select.is_a?(Enumerator)
array.my_select
array.my_select { |n| n % 2 == 0 }
range.my_select { |n| n % 2 == 0 }

# my_all?
range.my_all?(&false_block)
true_array.all?
true_array.my_all?
false_array.all?
false_array.my_all?

# my_any
false_block = proc { |num| num > 9 }
true_array = [1, true, 'hi', []]
true_array.my_any?
range.my_any?(&false_block)
array.my_any? { |n| n > 3 }
array.my_any? { |n| n > 100 }

%w[rabbit mouse dog].none? { |word| word.length == 5 }
%w[rabbit mouse dog].none? { |word| word.length >= 4 }

%w[rabbit mouse dog].my_none? { |word| word.length == 5 }
%w[rabbit mouse dog].my_none? { |word| word.length >= 4 }
ary = [1, 2, 4, 2]

ary.count
ary.count(2)
ary.count { |x| x.even? }

ary.my_count
ary.my_count(2)
ary.my_count { |x| x.even? }

p([1, 2, 3].map { |n| n * 3 })
p([1, 2, 3].my_map { |n| n * 3 })

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
