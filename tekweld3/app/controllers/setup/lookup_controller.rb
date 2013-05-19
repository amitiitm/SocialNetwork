class Setup::LookupController < ApplicationController
require 'hpricot'

  def list
    doc = Hpricot::XML(request.raw_post)   
    @list = Setup::LookupLib.list(doc)
#    respond_to do |wants|
#      wants.html 
#    end
    render :xml=>@list[0].xmlcol
  end

  def list_lookups
#    doc = Hpricot::XML(request.raw_post)   
    @list = Setup::LookupCrud.list_lookups()
#    respond_to do |wants|
#      wants.html 
#    end
    render_view(@list,'lookups','L')
  end

end
