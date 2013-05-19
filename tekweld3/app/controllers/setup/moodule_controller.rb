class Setup::MooduleController < ApplicationController
  include General
  include ClassMethods 
  require 'hpricot'
  
  def moodule_list
    doc = Hpricot::XML(request.raw_post)
    user_id = parse_xml(doc/'id')
    @moodule_list = Admin::GenerateMenuWorkflow.list_moodules(user_id)
    respond_to do |wants|
      wants.html
      wants.xml
    end 
  end
  
  def list_moodules
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @moodule_list = Admin::MenuCrud.list_moodules(doc)
    render_view(@moodule_list,"moodules","L")
  end

  def create_moodules
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @moodules = Admin::MenuCrud.create_moodules(doc)
    moodules =  @moodules.first if !@moodules.empty?
    if moodules.errors.empty?
      render_view(@moodules,"moodules","C")
    else
      respond_to_errors(moodules.errors)
    end 
  end

  def show_moodule
    doc = Hpricot::XML(request.raw_post)
    id=parse_xml(doc/:params/'id')
    @moodule = Admin::MenuCrud.show_moodule(id)
    render_view(@moodule,"moodules","L")
  end
end
