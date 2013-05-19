xml.instruct! :xml, :version=>"1.0" 
xml.documents{
  @documents.each {|document| 
#    if document.menus.empty?
      xml.document do
        xml.id(document.id) 
        xml.trans_flag(document.trans_flag)  
        xml.code(document.code) 
        xml.document_name(document.document_name)   
        xml.component_cd(document.component_cd)  
      end
#    end
  }
}