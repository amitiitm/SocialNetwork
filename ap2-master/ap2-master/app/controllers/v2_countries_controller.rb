class V2CountriesController < ApplicationController
  def index
    @countries = V2Country.find(:all, :conditions => {:import_rates => true}, :order => "LENGTH(country_code), country_code asc")
    resp
  end
  
  def edit
    @country = V2Country.find(params[:id])
    resp
  end
  
  def update
    @country = V2Country.find(params[:id])
    if @country.update_attributes(params[:v2_country])
      @success = true
    else
      @success = false
    end
  end
  
  def special_country
    
  end
end
