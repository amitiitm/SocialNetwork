class CardsInventoriesController < ApplicationController
  
  def index
    @inventories = CardsInventory.find(:all, :order => "cards_start asc" )
    resp
  end
  
  def edit
    @inventory = CardsInventory.find(params[:id])
    @inventory.return = true
    resp
  end
  
  def update
    @inventory = CardsInventory.find(params[:id])
    @path = cards_inventories_path
    resp @inventory.update_attributes(params[:cards_inventory])
  end
  
end
