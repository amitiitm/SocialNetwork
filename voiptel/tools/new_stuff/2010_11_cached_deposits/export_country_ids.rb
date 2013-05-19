f = File.new("/tmp/update_country_ids.sql", "w")
Cdr.find_in_batches(:select => "id, dst_number", :conditions => {:country_id => nil}) do |batch|
  batch.each do |cdr|
    d = Destination.new(cdr.dst_number, :country_only => true)
    if d.country
      country_id = d.country.id
    else
      country_id = "**"
    end
    f.write("UPDATE `cdrs` SET cdrs.country_id='#{country_id}' WHERE cdrs.id='#{cdr.id}';\n")
  end
end
f.close