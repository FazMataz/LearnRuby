def binary_search(array, item)
  midpoint = array.length/2
  if item == array[midpoint]
    midpoint
  elsif array.length <= 1
    false
  elsif item <= array[midpoint]
    binary_search(array[0..midpoint-1], item)
  elsif item >= array[midpoint]
    binary_search(array[midpoint..], item) ? midpoint + binary_search(array[midpoint..], item) : false
  end
  false
end

p binary_search([6,7,8,9,10,11,14,15,17,19,22,23,25,28,30], 16)

def level_order_traversal(array)
  queue = Queue.new
