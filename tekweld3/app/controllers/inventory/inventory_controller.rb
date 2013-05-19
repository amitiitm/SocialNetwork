class Inventory::InventoryController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods

  #Inventory Services
  def list_issue_transactions
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @inventory_transactions = Inventory::InventoryTransactionCrud.list_issue_transactions(doc)
    respond_to_action('list_inventory_transactions')
  end  

  def list_receive_transactions
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @inventory_transactions = Inventory::InventoryTransactionCrud.list_receive_transactions(doc)
    respond_to_action('list_inventory_transactions')
  end  

  def list_transfer_transactions
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @inventory_transactions = Inventory::InventoryTransactionCrud.list_transfer_transactions(doc)
    respond_to_action('list_inventory_transactions')
  end  

  def show_inventory_transaction
    doc = Hpricot::XML(request.raw_post)
    inventory_transaction_id  = parse_xml(doc/:params/'id')
    @inventory_transactions = Inventory::InventoryTransactionCrud.show_inventory_transaction(inventory_transaction_id)
    respond_to do |wants|
      wants.xml   
    end
  end  

  def show_inventory_transaction_transfer
    doc = Hpricot::XML(request.raw_post)
    inventory_transaction_id  = parse_xml(doc/:params/'id')
    @inventory_transactions = Inventory::InventoryTransactionCrud.show_inventory_transaction(inventory_transaction_id)
    respond_to do |wants|
      wants.xml   
    end
  end  

  def create_inventory_transactions
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @inventory_transactions= Inventory::InventoryTransactionCrud.create_inventory_transactions(doc)
    inventory_transaction =  @inventory_transactions.first if !@inventory_transactions.empty?
    if inventory_transaction.errors.empty?
      respond_to_action('show_inventory_transaction')
    else
      respond_to_errors(inventory_transaction.errors)
    end
  end
  
  def create_inventory_transaction_transfers
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @inventory_transactions= Inventory::InventoryTransactionCrud.create_inventory_transactions(doc)
    inventory_transaction =  @inventory_transactions.first if !@inventory_transactions.empty?
    if inventory_transaction.errors.empty?
      respond_to_action('show_inventory_transaction_transfer')
    else
      respond_to_errors(inventory_transaction.errors)
    end
  end
end
