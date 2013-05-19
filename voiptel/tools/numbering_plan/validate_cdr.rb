Cdr.find_in_batches() do |batches|
  batches.each do |cdr|
    d = Destination.new(cdr.dst_number)
    if d.valid?
      cdr.valid_destination = true
      cdr.save
    else
      cdr.valid_destination = false
    end
  end
end