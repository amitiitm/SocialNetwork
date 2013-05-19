class Inventory::InventorySummary < ActiveRecord::Base
  include Dbobject
  include General
  include ClassMethods

  belongs_to :catalog_item, :class_name => 'Item::CatalogItem'
  belongs_to :catalog_item_packet, :class_name => 'Item::CatalogItemPacket'
  attr_accessor :post_flag

  #  def validate
  #  if post_flag == 'P'
  #    check_inventory = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','invn','check_inventory'])
  #    if  check_inventory.value=='Y'
  #      #stock = (stock_rec_qty - stock_iss_qty ) + (memo_rec_qty - memo_iss_qty)
  #      if  catalog_item_packet_id == 0 
  #        inventory = Inventory::InventorySummary.find_by_sql ["select ( (sum(stock_rec_qty) - sum(stock_iss_qty) ) + (sum(memo_rec_qty) - sum(memo_iss_qty)) ) as stock_other
  #                                                            from inventory_summaries
  #                                                            where account_period_code <> ?
  #                                                            and catalog_item_id = ?",account_period_code,catalog_item_id]
  #      else
  #        inventory = Inventory::InventorySummary.find_by_sql ["select ( (sum(stock_rec_qty) - sum(stock_iss_qty) ) + (sum(memo_rec_qty) - sum(memo_iss_qty)) ) as stock_other
  #                                                            from inventory_summaries
  #                                                            where account_period_code <> ?
  #                                                            and catalog_item_id = ? and catalog_item_packet_id = ?",account_period_code,catalog_item_id,catalog_item_packet_id]
  #      end        
  #      stock = (stock_rec_qty - stock_iss_qty ) + (memo_rec_qty - memo_iss_qty) + nulltozero(inventory[0].stock_other.to_i)
  #      if  catalog_item_packet_id == 0 
  #        errors[:base] <<  "Item #{self.catalog_item.store_code} not in stock" if stock < 0 
  #      else
  #        errors[:base] <<  "Item #{self.catalog_item.store_code} with packet #{self.catalog_item_packet.code} not in stock" if stock < 0 
  #        errors[:base] <<  "Item #{self.catalog_item.store_code} with packet #{self.catalog_item_packet.code} can have only one qty in stock" if stock > 1 
  #      end
  #    end
  #  end
  #  end

  
 
  validate do
    if post_flag == 'P'
      check_inventory = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','invn','check_inventory'])
      if  check_inventory.value=='Y'
        stock = (stock_rec_qty - stock_iss_qty ) + (memo_rec_qty - memo_iss_qty)
       
        inventory = Inventory::InventorySummary.find_by_sql ["select ( (sum(stock_rec_qty) - sum(stock_iss_qty) ) + (sum(memo_rec_qty) - sum(memo_iss_qty)) ) as stock_other
                                                            from inventory_summaries
                                                            where account_period_code <> ?
                                                            and catalog_item_id = ? and catalog_item_packet_id = ?",account_period_code,catalog_item_id,catalog_item_packet_id]
         
        stock = (stock_rec_qty - stock_iss_qty ) + (memo_rec_qty - memo_iss_qty) + nulltozero(inventory[0].stock_other.to_i)
        if  catalog_item_packet_id == 0 
          errors[:base] <<  "Item #{self.catalog_item.store_code} not in stock" if stock < 0 
        else
          errors[:base] <<  "Item #{self.catalog_item.store_code} with packet #{self.catalog_item_packet.code} not in stock" if stock < 0 
          errors[:base] <<  "Item #{self.catalog_item.store_code} with packet #{self.catalog_item_packet.code} can have only one qty in stock" if stock > 1 
        end
      end
    end
  end

end
