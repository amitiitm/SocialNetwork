def quicksort(array)
  if array.length <= 1
    return array
  end
  less = Array.new
  greater = Array.new
  pivot = array[array.length/2]
  array.each do |x|
    if x < pivot
      less << x
    elsif x > pivot
      greater << x
    end
  end
  return (quicksort(less) << pivot << quicksort(greater)).flatten.compact
end
a = [9,4,10,12,3,5,10,3,2,25,6,21,33,23,19,13,38,26,12,3]
p quicksort(a)
##!/usr/bin/ruby
## quicksort.rb

#def quicksort(list, p, r)
#    if p < r then
#        q = partition(list, p, r)
#        quicksort(list, p, q-1)
#        quicksort(list, q+1, r)
#    end
#end
#
#def partition(list, p, r)
#    pivot = list[r]
#    i = p - 1
#    p.upto(r-1) do |j|
#        if list[j] <= pivot
#            i = i+1
#            list[i], list[j] = list[j],list[i]
#        end
#    end
#    list[i+1],list[r] = list[r],list[i+1]
#    return i + 1
#end
#
## Testing it out
#a = [9,4,10,12,3,5,10,3,2,25,6,21,33,23,19,13,38,26,12,3]
#quicksort(a, 0, a.length-1)
#puts a




# def quicksort a
#   (pivot = a.pop) ? quicksort(a.select{|i| i <= pivot}) + [pivot] + quicksort(a.select{|i| i > pivot}) : []
# end
#
# arr = [4444,333,22,222,1,2,4,5,6,7,4343,989]
# quicksort arr