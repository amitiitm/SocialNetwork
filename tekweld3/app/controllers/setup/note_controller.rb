class Setup::NoteController < ApplicationController
  include General
  include ClassMethods
  require 'hpricot'


  def list_notes
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @notes = Setup::NoteCrud.list_notes(doc)
    respond_to do |format|
      format.xml
    end
  end
 
  def create_notes
    doc = Hpricot::XML(request.raw_post)   
    @notes =  Setup::NoteCrud.create_notes(doc)
    table_name = parse_xml(doc/:notes/:note/:table_name) if (doc/:notes/:note/:table_name).first
    trans_id = parse_xml(doc/:notes/:note/:trans_id) if (doc/:notes/:note/:trans_id).first
    xml = %{
          <criteria>   
                  <str1>#{table_name}</str1>   
                  <int1>#{trans_id}</int1> 
                  <default_request>N</default_request>
          </criteria> 
    }
    doc = Hpricot::XML(xml)
    @notes = Setup::NoteCrud.list_notes(doc)
    respond_to do |format|
      format.xml do  
        render :template => "setup/note/list_notes"
      end
    end
  end
end
