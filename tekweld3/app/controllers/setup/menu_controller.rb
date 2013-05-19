class Setup::MenuController < ApplicationController
  #  include ContentModelMethods 
  include General
  include ClassMethods 
  require 'hpricot'
  
  def menu_list
    doc = Hpricot::XML(request.raw_post)
    @menu_list = Admin::GenerateMenuWorkflow.get_menu_list(doc)
#    render :xml=>@menu_list[0].xmlcol
        respond_to do |wants|
          wants.html
          wants.xml 
        end
  end

  ##   Menu list for query 
  def query_menu_list
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)  
    @menus = Admin::MenuCrud.list_of_menu_items(doc)
    respond_to do |wants|
      wants.html
      wants.xml 
    end
  end  
  
  ## To populate left side of menu accordion
  def documents_not_in_menu
    @documents = Admin::MenuCrud.find_documents_not_in_menu()
    respond_to do |wants|
      wants.html
      wants.xml
    end                               
  end
 
  ## Populate menus belonging to a module (with menu type = 'M' ) in menu accordion  
  def get_menu_items 
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @main_menu = Admin::MenuCrud.find_menu_items(doc)
    if @main_menu 
      respond_to do |wants|
        wants.html
        wants.xml 
      end 
    end
  end
 
  def create_menu
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    error = Admin::MenuCrud.create_menu(doc)
    if error == 'N'
      render :text => "Success" 
    else
      render :text=> "Failed" 
    end
  end  

  #### start of new code
  def list_menus
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @menu_list = Admin::MenuCrud.list_menus(doc)
    render_view(@menu_list,"menus","L")
  end

  def create_menus
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @menu = Admin::MenuCrud.create_menus(doc)
    menu =  @menu.first if !@menu.empty?
    if menu.errors.empty?
      render_view(@menu,"menus","C")
    else
      respond_to_errors(menu.errors)
    end 
  end

  def show_menu
    doc = Hpricot::XML(request.raw_post)
    id=parse_xml(doc/:params/'id')
    @menu = Admin::MenuCrud.show_menu(id)
    render_view(@menu,"menus","L")
  end 
end

