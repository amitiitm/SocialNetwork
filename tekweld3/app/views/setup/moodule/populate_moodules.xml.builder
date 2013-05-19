xml.instruct! :xml, :version=>"1.0" 
xml.moodules{
  for moodule in @moodules
      xml.moodule do 
      xml.moodule_name(moodule.moodule_name)   
      xml.code(moodule.code)  
      xml.id(moodule.id) 
    end
 end
}
