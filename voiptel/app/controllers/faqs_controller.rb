class FaqsController < ApplicationController
  def index
    @faqs = Faq.all
    @faq = Faq.new
    resp
  end
  
  def create
    @faq = Faq.new(params[:faq])
    resp(@faq.save)
  end

  def edit
    @faq = Faq.find(params[:id])
    resp
  end

  def destroy
    @faq = Faq.find(params[:id])
    @faq.delete
  end

  def update
    @faq = Faq.find(params[:id])
    resp @faq.update_attributes(params[:faq])
  end

end
