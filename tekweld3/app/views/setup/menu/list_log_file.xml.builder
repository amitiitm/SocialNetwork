xml.instruct! :xml, :version=>"1.0" 
xml.message{
  for er in @error
    !er[1] ?  xml.msg(er[0]) : xml.msg(er[1] + '  ' + er[0])
 end
}
