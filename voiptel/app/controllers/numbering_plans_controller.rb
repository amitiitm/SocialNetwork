class NumberingPlansController < ApplicationController
  def country_list
    @sort = params[:sort_by]
    if @sort == "country_code"
      @countries = Country.find(:all, :order => "country_code ASC")
    else 
      @countries = Country.find(:all, :order => "name ASC")
    end
  end
  
  def edit_country
    @country = Country.find(params[:id])
  end
  
  def area_code
    @country = params[:id]
    @area_codes = NumberingPlan.find(:all, :conditions => {:country_name_2_letters => @country})
  end
  
  def update_country
    country = Country.find(params[:id])
    country.update_attributes(params[:country])
  end
  
end
