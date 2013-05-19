class IvrsController < ApplicationController
  def index
    @ivrs = Ivr.all
    resp
  end
  
  def tree
    @ivrs = Ivr.find(:all, :conditions => {:parent_id => nil})
    resp
  end
  
  def show
    @ivr = Ivr.find(params[:id])
    resp
  end
  
  def new
    @ivr = Ivr.new
    resp
  end
  
  def create
    @ivr = Ivr.new(params[:ivr])
    @path = ivrs_path
    resp @ivr.save
  end
  
  def edit
    @ivr = Ivr.find(params[:id])
    resp
  end
  
  def update
    @ivr = Ivr.find(params[:id])
    @path = ivrs_path
    resp @ivr.update_attributes(params[:ivr])
  end
  
  def destroy
    @ivr = Ivr.find(params[:id])
    @path = ivrs_path
    resp @ivr.destroy
  end
end
