xml.instruct! :xml, :version=>"1.0" 
xml.errors{
    for er in @error
	xml.error(er)
      end  
}
