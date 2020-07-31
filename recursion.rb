# frozen_string_literal: true

def factorial(n)
  if n == 1
    1
  else
    n * factorial(n-1)
  end
end

def palindrome(string)
  if string.length <= 1
    true
  elsif string[0] == string[-1]
    palindrome(string[1..-2])
  else
    false
  end
end

def bottles_of_beer(n)
  if n > 0
    "#{n} bottles of beer on the wall! " + bottles_of_beer(n-1)
  else
    "no bottles of beer on the wall"
  end
end

def fibonacci(n)
  if n == 0
    0
  elsif n == 1
    1
  else
    fibonacci(n-1) + fibonacci(n-2)
  end
end

def flatten(array, result = [])
  array.each do |element|
    if element.kind_of?(Array)
      flatten(element, result)
    else
      result << element
    end
  end 
  result
end

def merge_sort(arr)
  #return n if n < 2
  return arr if arr.length < 2
  #else
    #sort left half
  left_half = merge_sort(arr[0..(arr.length/2)-1])
    #sort right half
  right_half = merge_sort(arr[arr.length/2..arr.length-1])
    #merge the sorted halves
  final_arr = []
  a = 0
  b = 0
  while final_arr.length < arr.length
    if left_half[a].nil?
      final_arr.push right_half[b]
      b += 1
    elsif right_half[b].nil?
      final_arr.push left_half[a]
      a += 1
    elsif left_half[a] < right_half[b]
      final_arr.push(left_half[a])
      a += 1
    else
      final_arr.push(right_half[b])
      b += 1
    end
  end
  final_arr
end

p merge_sort([5,2,1,3,6,4,7,1,2,46,8,0,1])