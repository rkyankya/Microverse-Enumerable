# frozen_string_literal: true
# rubocop:disable Metrics/ModuleLength

module Enumerable 
  def my_each
    return to_enum unless block_given?

    (0..length - 1).each do |i|
      yield(self[i])
    end
  end

  def my_map(&proc)
    temp = []
    each do |item|
      temp.push(proc.call(item)) if proc
      temp.push(yield(item)) if block_given? && !proc
    end
    temp = to_enum if temp.empty?
    temp
  end

  def my_each_with_index
    return to_enum unless block_given?

    (0..length - 1).each do |i|
      yield(self[i], i)
    end
  end

  def my_select
    return to_enum unless block_given?

    temp = []
    (0..length - 1).each do |i|
      temp << self[i] if yield(self[i])
    end
    temp
  end

  def my_any?(param = true)
    if block_given?
      each { |item| return true if yield(item) }
      return false
    end
    state = case param
            when Regexp then check_regexp(true, param)
            when Class then check_class(true, param)
            else check(true, param)
            end
    state == true ? state : false
  end

  def my_all?(param = true)
    if block_given?
      each { |item| return false unless yield(item) }
      return true
    end
    state = case param
            when Regexp then check_regexp(false, param, true)
            when Class then check_class(false, param, true)
            else check(false, param, true)
            end
    state == false ? state : true
  end

  def my_none?(param = true)
    if block_given?
      each { |item| return false if yield(item) }
      return true
    end
    state = case param
            when Regexp then check_regexp(false, param)
            when Class then check_class(false, param)
            else check(false, param)
            end
    state == false ? state : true
  end

  def check_regexp(status, param, negative = false)
    each { |item| return status unless param.match(item) } if negative
    each { |item| return status if param.match(item) } unless negative
  end

  def check_class(status, param, negative = false)
    each { |item| return status unless item.instance_of? param } if negative
    each { |item| return status if item.instance_of? param } unless negative
  end

  def check(status, param, negative = false)
    each do |item|
      cond = if param == true
               !item.nil? && item
             else
               item == param
             end

      cond = negative ? !cond : cond

      return status if cond
    end
  end

  def my_count(cond = nil)
    counter = 0
    each do |item|
      counter += 1 if (block_given? && yield(item)) || (item == cond) || (!cond && !block_given?)
    end
    counter
  end

  def my_inject(*args)
    acc = setup_acc(args)
    return multiply_els(self, acc) if args.include? :*

    return add_els(self, acc) if args.include? :+

    return divide_els(self, acc) if args.include? :/

    return subs_els(self, acc) if args.include? :-

    each { |item| acc = yield(acc, item) }
    acc
  end

  def setup_acc(param)
    if !param[0].is_a?(Symbol) && !param.empty?
      param[0]
    elsif param.my_all?(String) && param[0].is_a?(String) then param[0]
    elsif param.my_all?(String) then ''
    else 0
    end
  end

  def multiply_els(arr, accum)
    accum = accum.zero? ? 1 : accum
    arr.my_inject(accum) { |acc, item| acc * item }
  end

  def add_els(arr, accum)
    arr.my_inject(accum) { |acc, item| acc + item }
  end

  def divide_els(arr, accum)
    arr.my_inject(accum.to_f) { |acc, item| acc / item }
  end

  def subs_els(arr, accum)
    arr.my_inject(accum) { |acc, item| acc - item }
  end
end

# puts [1,2,3].my_all?{ |item| item<5}
# puts %w[s str string].my_none?(/g/)
# puts [1,2,3].my_none?{ |item| item<0}
# puts [false, false, false].my_none?

# puts [1,2,2].my_map { |item| item+2}

# puts([1, 2, 2].my_count(1))

# puts multiply_els([3, 2, 3]) FAULTY

# p ['s', 'tri', 'ng'].my_inject {|acc, item| acc+item}

# puts Range.new(5,20).inject(:+)
# puts ['s', 'tri', 'ng'].my_inject( &proc { |memo, word| memo.length > word.length ? memo : word })

# puts [1,2,nil].my_all?

# puts([1, 2, 3].my_map { |item| item + 2 })

# [1,2,3,4].my_each_with_index{ |item, index| puts index}
# puts [1,2,3,4].my_select{ |item| item.even?}
# [1,2,3].my_each { |item| puts item }

# puts [3,2,3].my_inject(2) { |acc, item| acc+item}

# puts Foo.is_a? Class

# puts /yey/.is_a? Regexp
#
