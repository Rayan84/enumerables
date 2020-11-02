# rubocop:disable Metrics/MethodLength
module Enumerable
  # my_each
  def my_each
    return enum_for(:my_each) unless block_given?

    arr = self if self.class == Array
    arr = to_a if self.class == Range || Hash
    0.upto(arr.length - 1) do |index|
      yield(arr[index])
    end
    arr
  end

  # my_each_with_index
  def my_each_with_index
    return enum_for(:my_each_with_index) unless block_given?

    arr = self if self.class == Array
    arr = to_a if self.class == Range || Hash

    0.upto(arr.size - 1) do |index|
      yield(arr[index], index)
    end
    arr
  end

  # my_select
  def my_select
    return enum_for(:my_select) unless block_given?

    new_a = []
    my_each do |element|
      new_a << element if yield(element)
    end
    new_a
  end

  # My_all?
  def my_all?(parameter = nil)
    if block_given?
      my_each { |item| return false if yield(item) == false }
      return true
    elsif parameter.nil?
      my_each { |n| return false if n.nil? || n == false }
    elsif !parameter.nil? && (parameter.is_a? Class)
      my_each { |n| return false unless [n.class, n.class.superclass].include?(parameter) }
    elsif !parameter.nil? && patameter.class == Regexp
      my_each { |n| return false unless parameter.match(n) }
    else
      my_each { |n| return false if n != parameter }
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
  def my_none?
    return enum_for(:my_none) unless block_given?

    my_each do |element|
      return false if yield(element)
    end
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

  def my_map(item = nil)
    new_a = []
    my_each do |element|
      new_a << if block_given?
                 yield(element)
               else
                 item.call(element)
               end
    end
    new_a
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

  def multiply_els(arr)
    arr.my_inject { |total, number| total * number }
  end
end
# rubocop:enable, Metrics/MethodLength
