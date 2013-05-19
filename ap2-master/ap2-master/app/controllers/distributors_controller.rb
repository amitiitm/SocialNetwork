class DistributorsController < ApplicationController
  def index
    @distributors = Distributor.all
    resp
  end
  
  def new
    resp
  end
  
  def create
    @distributor = Distributor.new(params[:distributor])
    @distributor.save
  end
  
  def show
    @distributor = Distributor.find(params[:id])
    @distributions = @distributor.distributions
    resp
  end
  
end
