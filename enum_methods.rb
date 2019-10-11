# frozen_string_literal: true

module Enumerable
  def my_each
    if block_given?
      for i in 0..self.length - 1
        yield(self[i])
      end
    end
  end

  def my_each_with_index
    if block_given?
      for i in 0..self.length - 1
        yield(self[i], i)
      end
    end
  end

  def my_select
    if block_given?
      r = []
      for i in 0..self.length - 1
        if yield(self[i])
          r.push(self[i])
        end
      end
      r
    end
  end

  def my_all?(arg1 = nil)
    if block_given?
      cnt = 0
      ln = self.length

      for i in 0..ln - 1
        if yield(self[i])
          cnt += 1
        end
      end
      if ln == cnt
        true
      else
        false
      end
    else
      if arg1 != nil
        cnt = 0
        ln = self.length
        for i in 0..ln - 1
          if self[i].class <= arg1
            cnt += 1
          end
        end
        if ln == cnt
          true
        else
          false
        end
      else
        cnt = 0
        ln = self.length
        for i in 0..ln - 1
          if self[0] == self[i].class
            cnt += 1
          end
        end
        if ln == cnt
          true
        else
          false
        end
      end
    end
  end

  def my_any?
    if block_given?
      for i in 0..self.length - 1
        if yield(self[i])
          return true
        end
      end
    end
    false
  end

  def my_none?
    if block_given?
      cnt = 0
      ln = self.length

      for i in 0..ln - 1
        if not yield(self[i])
          cnt += 1
        end
      end
      if ln == cnt
        true
      else
        false
      end
    else
      nil
    end
  end

  def my_count(obj = nil)
    if block_given?
      cnt = 0
      for i in 0..self.length - 1
        if yield(self[i])
          cnt += 1
        end
      end

      return cnt
    else
      cnt = 0
      if obj == nil
        return self.length
      else
        for i in 0..self.length - 1
          if obj == self[i]
            cnt += 1
          end
        end
        return cnt
      end
    end
  end

  def my_map
    if block_given?
      for i in 0..self.length - 1
        self[i] = yield(self[i])
      end
      self
    end
  end

  def my_inject(arg1 = 1, sbl = nil)
    if block_given?
      if arg1 != 1
        self.unshift(arg1)
      end

      acl = self[0]
      for i in 1..self.length - 1
        acl = yield(acl, self[i])
      end
      acl
    else
      if arg1.class == Symbol
        acl = self[0]
        for i in 1..self.length - 1
          acl = acl.send(arg1, self[i])
        end
        return acl
      end
      if arg1.class == Integer and sbl.class == Symbol

        if arg1 != 1
          self.unshift(arg1)
        end

        acl = self[0]
        for i in 1..self.length - 1
          acl = acl.send(sbl, self[i])
        end

        return acl
      end
    end
  end
end

def multiply_els(arr)
  return arr.my_inject(:*)
end

puts "---------"
puts "my_each"
arr = [1, 2, 3, 4, 5, 6]
arr.my_each do |num|
  puts num * num # prints out element squared
end

puts "---------"
puts "my_each_with_index"
arr = ["Billy", "Wild Bill", "Big Bill", "Coffdrop"]
arr.my_each_with_index do |nickname, val|
  puts "String: #{nickname}, Index: #{val}"
  # prints out each element with index
end

puts "---------"
puts "my_select"
arr = [12.2, 13.4, 15.5, 16.9, 10.2]
r = arr.my_select do |num|
  num.to_f > 13.3 # selects arr[1], arr[2], arr[3]
end

puts r

puts "---------"
puts "my_all"
arr = ["Johnny", "Jack", "Jim", "Jonesy"]
r = arr.my_all? do |name|
  name[0] == "J" # returns true for the given set
end

puts r

puts "---------"
puts "my_any"
arr = ["Billy", "Alex", "Brooke", "Andrea", "Willard"]
r = arr.my_any? do |name|
  name.match(/Bi/) # returns true for the given set
end

puts r

puts "---------"
puts "my_none"
arr = ["Billy", "Alex", "Brooke", "Andrea", "Willard"]
r = arr.my_none? do |name|
  name.match(/zzz/) # returns true for the given set
end

puts r

puts "---------"
puts "my_count"
arr = [1, 2, 3, 4, 5, 6, 7, 87, 33, 3]
run1 = arr.my_count do |val|
  val < 20 # returns 8 for the given set
end

run2 = arr.my_count(3) # returns 2 for the given set

run3 = arr.my_count # returns 10 for the given set
puts "Block: #{run1}, Param: #{run2}, No arg or param: #{run3}"

puts "---------"
puts "my_map"
arr = [1, 4, 16, 25, 36, 49]
run1 = arr.my_map do |val|
  val * 2 # doubles each value
end

run2 = arr.my_map

puts run1
puts run2

puts "---------"
puts "my_inject"
puts "calling multiply_els"
puts multiply_els([2, 4, 5])
puts "---------"
puts "startVal with symbol"
a = [2, 4, 5].my_inject(5, :*)
puts a
puts "---------"
puts "only block"
a = [5, 6, 7, 8, 9, 10].my_inject { |i, j| i + j }
puts a
puts "---------"
puts "startVal with block"
a = [5, 6, 7, 8, 9, 10].my_inject(5) { |i, j| i + j }
puts a
