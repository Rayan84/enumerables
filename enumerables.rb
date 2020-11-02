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
      length
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

  def my_inject(init = nil)
    return enum_for(:my_each_with_index) unless block_given?

    if init
      total = init
      start_index = 0
    else
      total = first
      start_index = 1
    end

    self[start_index...length].my_each do |element|
      total = yield(total, element)
    end
    total
  end
end
