xml.instruct! :xml, :version=>"1.0" 
xml.message{
    for er in @error
	xml.msg(er)
      end  
}
