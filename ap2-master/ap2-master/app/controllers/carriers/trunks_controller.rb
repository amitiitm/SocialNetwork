class Carriers::TrunksController < ApplicationController
  def create
    @carrier = Carrier.find(params[:carrier_id])
    @trunk = Trunk.new(params[:trunk])
    if @trunk.save
      @error = false
      @carrier.trunks << @trunk
      @carrier.save
    else
      @error = @trunk.errors.full_messages.join("\n")
    end        
  end
  
  def edit
    @carrier = Carrier.find(params[:carrier_id])
    @trunk = Trunk.find(params[:id])
  end
  
  def update
    @carrier = Carrier.find(params[:carrier_id])
    @trunk = Trunk.find(params[:id])
    if @trunk.update_attributes(params[:trunk])      
      @error = false
    else
      @error = @trunk.errors.full_messages.join("\n")
    end
  end
  
  def destroy
    @trunk = Trunk.find(params[:id])
    @trunk.destroy
  end
end
