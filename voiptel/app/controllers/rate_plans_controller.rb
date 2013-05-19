class RatePlansController < ApplicationController
  def index
    @rate_plans = RatePlan.all
    resp
  end
  
  def show
    @rate_plan = RatePlan.find(params[:id])
    resp
  end
  
  def new
    @rate_plan = RatePlan.new
    @rate_plan.promotions << Promotion.new(:rate => 0)
    resp
  end
  
  def create
    @rate_plan = RatePlan.new(params[:rate_plan])
    @path = rate_plans_path
    resp @rate_plan.save
  end
  
  def edit
    @rate_plan = RatePlan.find(params[:id])
    resp
  end
  
  def update
    @rate_plan = RatePlan.find(params[:id])
    @path = rate_plans_path
    resp @rate_plan.update_attributes(params[:rate_plan])
  end
  
  def destroy
    @rate_plan = RatePlan.find(params[:id])
    @path = rate_plans_path
    resp @rate_plan.destroy
  end
end
