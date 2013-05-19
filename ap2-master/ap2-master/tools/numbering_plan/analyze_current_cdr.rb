h = Hash.new
=begin
Cdr.find_in_batches do |batch|
  batch.each do |cdr|
    d = Destination.new(cdr.dst_number)
    if not d.found_numbering_plan? and cdr.duration > 50 and cdr.dst_number.length > 3
      unless h[cdr.dst_number]
        h[cdr.dst_number] = true
        puts cdr.dst_number
      end
    end
  end
end
=end

Cdr.find_in_batches do |batch|
  batch.each do |cdr|
    d = Destination.new(cdr.dst_number)
    if not d.found_numbering_plan? and cdr.dst_number.length > 3
      unless h[cdr.dst_number]
        h[cdr.dst_number] = true
        puts "#{d.country_name},#{cdr.dst_number},#{cdr.disposition},#{cdr.duration}"
      end
    end
  end
end