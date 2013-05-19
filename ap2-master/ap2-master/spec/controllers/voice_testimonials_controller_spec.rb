require File.dirname(__FILE__) + '/../spec_helper'

describe VoiceTestimonialsController do
  fixtures :all
  integrate_views

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
  
  it "show action should render show template" do
    get :show, :id => VoiceTestimonial.first
    response.should render_template(:show)
  end
  
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid" do
    VoiceTestimonial.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    VoiceTestimonial.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(voice_testimonial_url(assigns[:voice_testimonial]))
  end
  
  it "edit action should render edit template" do
    get :edit, :id => VoiceTestimonial.first
    response.should render_template(:edit)
  end
  
  it "update action should render edit template when model is invalid" do
    VoiceTestimonial.any_instance.stubs(:valid?).returns(false)
    put :update, :id => VoiceTestimonial.first
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    VoiceTestimonial.any_instance.stubs(:valid?).returns(true)
    put :update, :id => VoiceTestimonial.first
    response.should redirect_to(voice_testimonial_url(assigns[:voice_testimonial]))
  end
  
  it "destroy action should destroy model and redirect to index action" do
    voice_testimonial = VoiceTestimonial.first
    delete :destroy, :id => voice_testimonial
    response.should redirect_to(voice_testimonials_url)
    VoiceTestimonial.exists?(voice_testimonial.id).should be_false
  end
end
