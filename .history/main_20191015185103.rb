module Enumerable
  def my_each
    return self unless block_given?

    (0..length - 1).each do |i|
      yield(self[i])
    end
  end

  def my_map(&proc)
    temp = []
    if proc || block_given?
      (0..length - 1).each do |i|
        temp << [proc.call(self[i])] if proc
        temp << yield(self[i]) if block_given? && !proc
      end
    else temp = self
    end
    temp
  end

  def my_each_with_index
    return self unless block_given?

    (0..length - 1).each do |i|
      yield(self[i], i)
    end
  end

  def my_select
    return self unless block_given?

    temp = []
    (0..length - 1).each do |i|
      temp << self[i] if yield(self[i])
    end
    temp
  end

  def my_any?(param = true)
    if block_given?
      each { |item| return true if yield(item) }
    elsif param.is_a? Regexp
      each { |item| return true if param.match(item) }
    elsif param.is_a? Class
      each { |item| return true if item.instance_of? param }
    else
      each { |item| return true if item == param }
    end
    false
  end

  def my_all?(param = true)
    if block_given?
      each { |item| return false unless yield(item) }
    elsif param.is_a? Regexp
      each { |item| return false unless param.match(item) }
    elsif param.is_a? Class
      each { |item| return false unless item.instance_of? param }
    else
      each { |item| return false unless item == param }
    end
    true
  end

  def my_none?(param = true)
    if block_given?
      each { |item| return false if yield(item) }
    elsif param.is_a? Regexp
      each { |item| return false if param.match(item) }
    elsif param.is_a? Class
      each { |item| return false if item.instance_of? param }
    else
      each { |item| return false if item == param }
    end
    true
  end

  def my_count(cond = nil)
    counter = 0
    each do |item|
      counter += 1 if (block_given? && yield(item)) || (item == cond) || !cond
    end
    counter
  end

  def my_inject(*args)
    acc = 0
    acc = args[0] if !args[0].is_a?(Symbol) && !args.empty?

    return multiply_els(self) if args.include? :*

    return add_els(self) if args.include? :+

    return divide_els(self) if args.include? :/

    return subs_els(self) if args.include? :-


    each do |item|
      acc = yield(acc, item)
    end
    acc
  end

  def multiply_els(arr)
    arr.my_inject(1) { |acc, item| acc * item }
  end

  def add_els(arr)
    arr.my_inject(0) { |acc, item| acc + item }
  end

  def divide_els(arr)
    arr.my_inject(1.0) { |acc, item| acc / item }
  end

  def subs_els(arr)
    arr.my_inject(0) { |acc, item| acc - item }
  end
end



# puts [1,2,3].my_all?{ |item| item<0}
# puts %w[s str string].my_any?(/c/)
# puts [1,2,3].my_none?{ |item| item==3}
# puts [false, false, false].my_none?

# puts [true,true,2].my_map

# puts([1, 2, 2].my_count { |item| item==2 })

# puts multiply_els([3, 2, 3])

# puts([1, 2, 3].my_inject(0) { |acc, item| acc + item })

# mr = proc { |item| item + 2 }

# puts([1, 2, 3].my_map(&mr))
# puts([1, 2, 3].my_map { |item| item + 2 })

# [1,2,3,4].my_each_with_index{ |item, index| puts index}
# puts [1,2,3,4].my_select{ |item| item.even?}
# [1,2,3].my_each { |item| puts item }

# puts [3,2,3].my_inject(:/)

# class Foo
#
# end
#
# puts Foo.is_a? Class
#
# puts /yey/.is_a? Regexp
