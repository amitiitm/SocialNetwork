class Carriers::EndpointsController < ApplicationController
  
  def create
    @carrier = Carrier.find(params[:carrier_id])
    @endpoint = Endpoint.new(params[:endpoint])
    if @endpoint.save
      @error = false
      @carrier.endpoints << @endpoint
      @carrier.save
    else
      @error = @endpoint.errors.full_messages.join("\n")
    end        
  end
  
  def edit
    @carrier = Carrier.find(params[:carrier_id])
    @endpoint = Endpoint.find(params[:id])
  end
  
  def update
    @carrier = Carrier.find(params[:carrier_id])
    @endpoint = Endpoint.find(params[:id])
    if @endpoint.update_attributes(params[:endpoint])
      @error = false
    else
      @error = @endpoint.errors.full_messages.join("\n")
    end
  end
  
  def destroy
    @endpoint = Endpoint.find(params[:id])
    @endpoint.destroy
  end
  
end
