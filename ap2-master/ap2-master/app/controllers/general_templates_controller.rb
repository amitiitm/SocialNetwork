class GeneralTemplatesController < ApplicationController
  def index
    @general_templates = GeneralTemplate.all
    resp
  end
  
  def show
    @general_template = GeneralTemplate.find(params[:id])
    resp
  end
  
  def new
    @general_template = GeneralTemplate.new
    resp
  end
  
  def create
    @general_template = GeneralTemplate.new(params[:general_template])
    @path = general_templates_path
    resp @general_template.save
  end
  
  def edit
    @general_template = GeneralTemplate.find(params[:id])
    resp
  end
  
  def update
    @general_template = GeneralTemplate.find(params[:id])
    @path = general_templates_path
    resp @general_template.update_attributes(params[:general_template])
  end
  
  def destroy
    @general_template = GeneralTemplate.find(params[:id])
    @path = general_templates_path
    resp @general_template.destroy
  end
end
