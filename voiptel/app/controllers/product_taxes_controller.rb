class ProductTaxesController < ApplicationController
  def index
    @product_taxes = ProductTax.all
    resp
  end
  
  def show
    @product_tax = ProductTax.find(params[:id])
    resp
  end
  
  def new
    @product_tax = ProductTax.new
    resp
  end
  
  def create
    @product_tax = ProductTax.new(params[:product_tax])
    @path = product_taxes_path
    resp @product_tax.save
  end
  
  def edit
    @product_tax = ProductTax.find(params[:id])
    resp
  end
  
  def update
    @product_tax = ProductTax.find(params[:id])
    @path = product_taxes_path
    resp @product_tax.update_attributes(params[:product_tax])
  end
  
  def destroy
    @product_tax = ProductTax.find(params[:id])
    @path = product_taxes_path
    resp @product_tax.destroy
  end
end
