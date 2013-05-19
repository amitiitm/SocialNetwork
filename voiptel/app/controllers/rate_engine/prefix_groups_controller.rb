class RateEngine::PrefixGroupsController < ApplicationController
  def index
    @countries = V2Country.find(:all, :conditions => {:import_rates => true}, :order => "name asc").map {|c| [c.name, c.id]}
  end
  
  def show
    @country = V2Country.find(params[:id])
    resp
  end
end
