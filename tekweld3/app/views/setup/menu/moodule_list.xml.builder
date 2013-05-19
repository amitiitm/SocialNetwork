
xml.instruct! :xml, :version=>"1.0" 
xml.moodules{
  for moodule in @moodule_list
      xml.moodule do
      xml.id(moodule.moodule_id) 
      xml.code(moodule.moodule.code)
      xml.name(moodule.moodule.moodule_name)
    end
 end
}



