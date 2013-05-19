class TestimonialsController < ApplicationController
  
  def index    
    @testimonials = Testimonial.find(:all, :order => "created_at DESC")
    resp
  end
  
  def publish
    testimonial = Testimonial.find(params[:id])
    testimonial.publish = params[:publish]
    testimonial.save
    render :text => ""
  end
  
  def edit
    @testimonial = Testimonial.find(params[:id])
    @billing_city = ""
    if @testimonial.user.account.transaction_references.size > 0
      if @testimonial.user.account.transaction_references[0].address
        @billing_city = @testimonial.user.account.transaction_references[0].address.city
      end
    end
    @phone_cities = []    
    resp
  end
  
  def new
    @testimonial = Testimonial.new
    resp
  end
  
  def load
    @user = User.find(params[:user_id])
    @billing_city = ""
    if @user.account.transaction_references.size > 0
      if @user.account.transaction_references[0].address
        @billing_city = @user.account.transaction_references[0].address.city
      end
    end    
  end
  
  def create
    testimonial = Testimonial.new(params[:testimonial])
    
    @error = false
    unless testimonial.save
      @error = testimonial.errors.full_messages
    end    
  end
  
  def update
    begin
      if Testimonial.find(params[:id]).update_attributes(params[:testimonial])
        @success = true
      else
        @success = false
      end
    rescue
      @success = false
    end
  end
  
  def destroy
    Testimonial.find(params[:id]).delete
  end
  
end
