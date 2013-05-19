require File.dirname(__FILE__) + '/../spec_helper'

describe RatePlansController do
  fixtures :all
  integrate_views

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
  
  it "show action should render show template" do
    get :show, :id => RatePlan.first
    response.should render_template(:show)
  end
  
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid" do
    RatePlan.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    RatePlan.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(rate_plan_url(assigns[:rate_plan]))
  end
  
  it "edit action should render edit template" do
    get :edit, :id => RatePlan.first
    response.should render_template(:edit)
  end
  
  it "update action should render edit template when model is invalid" do
    RatePlan.any_instance.stubs(:valid?).returns(false)
    put :update, :id => RatePlan.first
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    RatePlan.any_instance.stubs(:valid?).returns(true)
    put :update, :id => RatePlan.first
    response.should redirect_to(rate_plan_url(assigns[:rate_plan]))
  end
  
  it "destroy action should destroy model and redirect to index action" do
    rate_plan = RatePlan.first
    delete :destroy, :id => rate_plan
    response.should redirect_to(rate_plans_url)
    RatePlan.exists?(rate_plan.id).should be_false
  end
end
