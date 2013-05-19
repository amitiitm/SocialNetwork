class Setup::RoleController < ApplicationController
  include General
  include ClassMethods 
  require 'hpricot'
  
  def list_roles
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @role_list = Admin::RoleCrud.list_roles(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@role_list[0].xmlcol))+'</encoded>'
#    render_view(@role_list,"roles","L")
  end

  def create_roles
    doc = Hpricot::XML(request.raw_post)   
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @roles = Admin::RoleCrud.create_roles(doc)
    roles =  @roles.first if !@roles.empty?
    if roles.errors.empty?
      render_view(@roles,"roles","C") 
    else
      respond_to_errors(roles.errors)
    end 
  end

  def show_role
    doc = Hpricot::XML(request.raw_post)
    id=parse_xml(doc/:params/'id')
    @role = Admin::RoleCrud.show_role(id)
    render_view(@role,"roles","L")
  end

  def create_role_permissions
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)  
    @role_permission = Admin::RolePermissionCrud.create_role_permissions(doc)
    role_permission =  @role_permission.first if !@role_permission.empty?
    if role_permission.errors.empty?
      respond_to_action("create_role_permissions") 
    else
      respond_to_errors(role_permission.errors)
    end 
  end
end
