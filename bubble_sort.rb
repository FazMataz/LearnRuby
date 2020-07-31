def bubble_sort(array)
    sorted = false
    p array
    while sorted == false 
        already_sorted = 0
        array.each_with_index do |val, i|
            if array[i+1] && array[i] > array[i+1]
                p "Compared #{array[i]} and #{array[i+1]} (#{val}), made swap."
                array[i] = array[i+1]
                array[i+1] = val
                already_sorted = 0
                p array
            else
                p "Compared #{array[i]} and #{array[i+1]} (#{val}), no swap."
                already_sorted +=1
                p array
            end
        end
        if already_sorted >= array.length - 1
            sorted = true
        end
    end
    return array
end



print bubble_sort([4,3,78,2,0,2])