class Report::CriteriaController < ApplicationController
  require 'hpricot'
 
  def criteria
  end
  
  def list_by_user_doc
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @criterias = Setup::CriteriaCrud.list_by_user_doc(doc)
    render_view(@criterias,'criterias','L')
  end

  def create_criterias
    #   Connection.establish_connection_schema('test1067')
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @criterias= Setup::CriteriaCrud.create_criterias(doc)
    render_view(@criterias,'criterias','C')
  end
  
end
