class Production::ThreadColorController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods

  #Term services
  def list_thread_colors
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @threads = Production::ThreadColorCrud.list_thread_colors(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@threads[0].xmlcol))+'</encoded>'
  end

  def show_thread_color
    doc = Hpricot::XML(request.raw_post)
    id  = parse_xml(doc/:params/'id')
    @threads = Production::ThreadColorCrud.show_thread_color(id)
    render_view( @threads,'terms','L')
  end

  def create_thread_colors
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @threads = Production::ThreadColorCrud.create_thread_colors(doc)
    term =  @threads.first if !@threads.empty?
    if term.errors.empty?
      render_view( @threads,'terms','C')
    else
      respond_to_errors(term.errors)
    end
  end
end