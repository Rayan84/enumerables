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
  def my_each_with_index
    if block_given?
      arr = if is_a?(Range)
              to_a
            else
              self
            end
      (0..arr.length - 1).each do |index|
        yield(arr[index], index)
      end
      self
    else
      to_enum :my_each_with_index
    end
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
        return false if yield(arr[i]) == false
      end
    else
      puts 'block was not given'
      puts arr.class
      puts arg.class
      if arg.class == Regexp
        arr.length.times do |i|
          unless arr[i].to_s.include?(arg.source)
            puts(" array item #{arr[i]} doesn't equal argument #{arg.source}, rendering false")
            return false
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

  def my_inject(init = nil, arg = nil)
    count = 0
    if init.nil? && arg.nil?
      ary = if is_a?(Range)
              to_a
            else
              self
            end
      my_each_with_index do |element, index|
        break if index + 1 == ary.length

        count = if index.zero?
                  yield(element, ary[index + 1])
                else
                  yield(count, ary[index + 1])
                end
      end
    elsif arg.nil?
      if init.class == Symbol
        arg = init
        ary = if self.class == Range
                to_a
              else
                self
              end
        ary.my_each_with_index do |element, index|
          break if index + 1 == ary.length

          count = if index.zero?
                    element.public_send arg.to_s, ary[index + 1]
                  else
                    count.public_send arg.to_s, ary[index + 1]
                  end
        end
      else
        count = init
        my_each do |element|
          count = yield(count, element)
        end
      end
    else
      count = init
      my_each do |element|
        count = count.public_send arg.to_s, element
      end
    end
    count
  end

  def multiply_els(my_array)
    my_array.my_inject(:*)
  end
end
