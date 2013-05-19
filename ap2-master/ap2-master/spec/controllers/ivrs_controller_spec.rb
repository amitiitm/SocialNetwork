require File.dirname(__FILE__) + '/../spec_helper'

describe IvrsController do
  fixtures :all
  integrate_views

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
  
  it "show action should render show template" do
    get :show, :id => Ivr.first
    response.should render_template(:show)
  end
  
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid" do
    Ivr.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    Ivr.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(ivr_url(assigns[:ivr]))
  end
  
  it "edit action should render edit template" do
    get :edit, :id => Ivr.first
    response.should render_template(:edit)
  end
  
  it "update action should render edit template when model is invalid" do
    Ivr.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Ivr.first
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    Ivr.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Ivr.first
    response.should redirect_to(ivr_url(assigns[:ivr]))
  end
  
  it "destroy action should destroy model and redirect to index action" do
    ivr = Ivr.first
    delete :destroy, :id => ivr
    response.should redirect_to(ivrs_url)
    Ivr.exists?(ivr.id).should be_false
  end
end
