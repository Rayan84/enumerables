require './enumerables'

describe Enumerable do
  let(:array) { [1, 2, 3] }
  describe '#my_each' do
    it 'Calls the given block once for each element in self' do
      expect(array.my_each { |ele| puts ele }).to eql(array.each { |ele| puts ele })
    end
  end

  describe '#my_each_with_index()' do
    it 'Calls the given block once for each element in self with its index' do
      expect(array.my_each_with_index do |ele, index|
               puts ele if index.even?
             end).to eql(array.each_with_index do |ele, index|
                           puts ele if index.even?
                         end)
    end
  end

  describe '#my_select()' do
    it 'Returns a new array containing all elements of ary for which the given block returns a true value' do
      expect(array.my_select { |ele| ele if ele != 2 }).to eql(array.select { |ele| ele if ele != 2 })
    end
  end

  describe '#my_all?()' do
    it 'Returns True if all elements in an array pass the given block' do
      expect(array.my_all? { |ele| ele > 100 }).to eql(array.all? { |ele| ele > 100 })
    end
  end

  describe '#my_any?()' do
    it 'Returns true if any of the elements in an array pass the given block' do
      expect(array.my_any? { |ele| ele == 2 }).to eql(array.any? { |ele| ele == 2 })
    end
  end

  describe '#my_none?' do
    it 'Returns true if none of the elements of an array pass the given block' do
      expect(array.my_none? { |ele| ele == 1 }).to eql(array.none? { |ele| ele == 1 })
    end
  end

  describe '#my_count' do
    it 'Returns the total number of elements of an array that pass the give block' do
      expect(array.my_count(&:even?)).to eql(array.count(&:even?))
    end
  end

  describe '#my_map' do
    it 'Returns a new array with the result of running a give block once every element in the array' do
      expect(array.my_map(&:odd?)).to eql(array.map(&:odd?))
    end
  end

  describe '#my_inject' do
    it 'Combines all elements of an array by applying a binary operation, specified by a block or a symbol that names a method or operator.' do
      expect(array.my_inject { |sum, n| sum + n }).to eql(array.inject { |sum, n| sum + n })
    end
  end
end
