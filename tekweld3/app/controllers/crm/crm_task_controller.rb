class Crm::CrmTaskController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  def list_tasks
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @tasks = Crm::CrmTaskCrud.list_tasks(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@tasks[0].xmlcol))+'</encoded>'
  end
 
  def show_tasks
    doc = Hpricot::XML(request.raw_post)   
    task_id = parse_xml(doc/'id') 
    @tasks = Crm::CrmTaskCrud.show_tasks(task_id)
    render_view( @tasks,'crm_tasks','L') 
  end
 
  def create_tasks
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @tasks = Crm::CrmTaskCrud.create_tasks(doc)  
    task =  @tasks.first if !@tasks.empty?
    if task.errors.empty?
      render_view( @tasks,'crm_tasks','C')
    else
      respond_to_errors(task.errors)
    end   
  end
end
