#def equi2( a )
#  sum=0
#  for i in 0...a.length
#    sum = a[i] + sum
#    if sum.to_i == 0
#      return i.to_i+1
#    else
#      -1
#    end
#  end
#end
#
#
#def equi1(a)
#  for i in 0...a.length
#    first = 0
#    second = 0
#    for j in 0..i
#      first = first+a[j]
#    end
#    for k in i+2...a.length
#      second = second+a[k]
#    end
#    if first == second
#      return i+1
#    else
#      -1
#    end
#  end
#end
#
#def equi ( a )
#   return -1 if a.empty?
#  return -1 if a.length > 10000000 and a.length < 0
#  for i in 0...a.length
#    if a[i] > -2147483648  and a[i] < 2147483647
#
#      if equi1(a) != -1
#       return equi1(a)
#      elsif equi2(a) != -1
#       return  equi2(a)
#      else
#        return -1
#      end
#    else
#      return -1
#    end
#
#  end
#end
#
#





#def complementary_pairs( k,a )
#  return -1 if a.empty?
#  return -1 if a.length > 50000 and a.length < 1
#  return -1 if k < -2147483648 || k > 2147483647
#  for i in 0...a.length
#    if a[i] < -2147483648  and a[i] > 2147483647
#      return -1
#    end
#  end
#  counter = 0
#  for i in 0...a.length
#    for j in 0...a.length
#      counter = counter + 1 if k == a[i] + a[j]
#    end
#  end
#  return counter
#end
##a=[]
#a = [1,8,-3,0,1,3,-2,4,5]
#k = 2147483649
#puts b = complementary_pairs( k,a )

def count_div( a,b,k )
  return -1 if a > b || (k < 1 || k > 2000000000) || (a < 0 || a > 2000000000) || (b < 0 || b > 2000000000)
  counter = 0
  for i in a..b
    if (i%k == 0)
      counter = counter + 1
    end
  end
  return counter
end

a=12;b=12;k=13
puts b = count_div( a,b,k )