module Enumerable
  # my_each

  def my_each
    if block_given?
      if is_a?(Range)
        arr = to_a
        arr.each do |value|
          yield(value)
        end
      else
        each do |value|
          yield(value)
        end
      end
      self
    else
      to_enum :my_each
    end
  end

  # my_each_with_index
  def my_each_with_index()
    return to_enum(:my_each_with_index) unless block_given?

    size.times do |i|
      yield(to_a[i], i)
    end
    self
  end

  def my_select
    return enum_for(:my_select) unless block_given?

    new_a = []
    my_each do |element|
      new_a << element if yield(element)
    end
    new_a
  end

  # My_all?
  def my_all?(arg = nil)
    arr = to_a if self.class == Range
    arr = self if self.class != Range
    if block_given?
      arr.length.times do |i|
        return false if yield(arr[i]) == false
      end
    else
      puts 'block was not given'
      puts "self class is #{arr.class}"
      puts "argument class is #{arg.class}"
      if !arg.nil?
        arr.length.times do |i|
          if arg.class == Integer
            unless arr[i].to_s.include?(arg.to_s)
              puts(" array item #{arr[i]} doesn't equal argument #{arg}, rendering false")
              return false
            end
          elsif arg.class == Class
            unless arr[i].class == arg
              puts(" array item #{arr[i]} doesn't equal argument #{arg}, rendering false")
              return false
            end
          else
            unless arr[i].to_s.include?(arg.source)
              puts(" array item #{arr[i]} doesn't equal argument #{arg.source}, rendering false")
              return false
            end
          end
        end
      else
        arr.length.times do |i|
          if arr[i] == false || arr[i].nil?
            puts arr[i]
            return false
          end
        end
      end
    end
    true
  end

  # my_any?
  def my_any?(parameter = nil)
    if block_given?
      my_each { |item| return true if yield(item) }
      false
    elsif parameter.nil?
      my_each { |n| return true if n }
    elsif !parameter.nil? && (parameter.is_a? Class)
      my_each { |n| return true if [n.class, n.class.superclass].include?(parameter) }
    elsif !parameter.nil? && parameter.class == Regexp
      my_each { |n| return true if parameter.match(n) }
    else
      my_each { |n| return true if n == parameter }
    end
    false
  end

  # none?
  def my_none?(arg = nil)
    arr = to_a if self.class == Range
    arr = self if self.class != Range
    if block_given?
      arr.length.times do |i|
        return false if yield(arr[i]) == true
      end
    elsif !arg.nil?
      arr.length.times do |i|
        if arg.class == Integer
          return false if arr[i].to_s.include?(arg.to_s)
        elsif arg.class == Class
          return true unless arr[i].class == arg
        else
          return true unless arr[i].to_s.include?(arg.source)
        end
      end
    else
      puts 'Argument not given'
      arr.length.times do |i|
        return false unless arr[i] == false || arr[i].nil?
      end
    end
    true
  end

  def my_count(item = nil)
    counter = 0

    if block_given?
      my_each do |element|
        counter += 1 if yield(element)
      end

      return counter
    end

    if item
      my_each do |element|
        counter += 1 if element == item
      end
      counter
    else
      arr = self if self.class == Array
      arr = to_a if self.class == Range || Hash
      arr.length
    end
  end

  def my_map(proc1 = nil)
    if block_given?
      new_arr = []
      my_each do |element|
        new_arr << if proc1.nil?
                     yield(element)
                   else
                     proc1.call(element)
                   end
      end
      new_arr
    else
      to_enum :my_map
    end
  end

  def my_inject(*arg)
    array = to_a
    arg1 = arg[0]
    arg2 = arg[1]

    both_args = arg1 && arg2
    only_one_arg = arg1 && !arg2
    no_arg = !arg1

    raise LocalJumpError if !block_given? && no_arg

    result = both_args || (only_one_arg && block_given?) ? arg1 : array.first

    if block_given?
      array.drop(1).my_each { |next_element| result = yield(result, next_element) } if no_arg

      array.my_each { |next_element| result = yield(result, next_element) } if only_one_arg
    else
      array.drop(1).my_each { |next_element| result = result.send(arg1, next_element) } if only_one_arg

      array.my_each { |next_element| result = result.send(arg2, next_element) } if both_args
    end
    result
  end

  def multiply_els(my_array)
    my_array.my_inject(:*)
  end
end
