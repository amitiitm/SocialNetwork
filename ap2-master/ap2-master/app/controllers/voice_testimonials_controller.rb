class VoiceTestimonialsController < ApplicationController
  def index
    @voice_testimonials = VoiceTestimonial.all
    resp
  end
  
  def show
    @voice_testimonial = VoiceTestimonial.find(params[:id])
    resp
  end
  
  def new
    @voice_testimonial = VoiceTestimonial.new
    resp
  end
  
  def create
    @voice_testimonial = VoiceTestimonial.new(params[:voice_testimonial])
    @path = voice_testimonials_path
    resp @voice_testimonial.save
  end
  
  def edit
    @voice_testimonial = VoiceTestimonial.find(params[:id])
    resp
  end
  
  def update
    @voice_testimonial = VoiceTestimonial.find(params[:id])
    @path = voice_testimonials_path
    resp @voice_testimonial.update_attributes(params[:voice_testimonial])
  end
  
  def destroy
    @voice_testimonial = VoiceTestimonial.find(params[:id])
    @path = voice_testimonials_path
    resp @voice_testimonial.destroy
  end
end
