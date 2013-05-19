xml.instruct! :xml, :version=>"1.0" 
xml.errors{
    for er in @userpreference
    xml.error do
	xml.field(er[0]) 
	xml.error(er[1]) 
   end
 end
}
