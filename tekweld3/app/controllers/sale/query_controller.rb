class Sale::QueryController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods

  def list_order_query_inbox
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @queries = Sales::QueryCrud.list_order_query_inbox(doc)
    render :xml=>@queries[0].xmlcol
  end

  def list_artwork_query_inbox
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @queries = Sales::QueryCrud.list_artwork_query_inbox(doc)
    render :xml=>@queries[0].xmlcol
  end

  def show_query
    doc = Hpricot::XML(request.raw_post)
    query_id  = parse_xml(doc/:params/'id')
    @queries = Sales::QueryCrud.show_query(query_id)
    respond_to_action('show_query')
    #    render_view( @queries,'queries','L')
  end

  def create_queries
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @queries = Sales::QueryCrud.create_queries(doc)
    query =  @queries.first if !@queries.empty?
    if query.errors.empty?
      respond_to_action('show_query')
      #      render_view( @queries,'queries','L')
    else
      respond_to_errors(query.errors)
    end
  end
end
