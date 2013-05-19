class DistributionsController < ApplicationController
  def index
    @distributions = Distribution.all
    resp
  end
  
  def new
    @distribution = Distribution.new
    resp
  end
  
  def create
    @distribution = Distribution.new(params[:distribution])
    @distribution.save
  end
  
  def edit
    @distribution = Distribution.find(params[:id])
    resp
  end
  
  def show
    @distribution = Distribution.find(params[:id])
    resp
  end
end
