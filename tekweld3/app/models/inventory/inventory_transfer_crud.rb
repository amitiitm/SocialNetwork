class Inventory::InventoryTransferCrud
include General

#Inventory Transfer services  
def self.list_transfer_inwards(doc)
  criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
#  Inventory::InventoryTransfer.active.find(:all,
#                    :joins => "join catalog_items on catalog_items.id = inventory_transfers.catalog_item_id 
#                              join companies on companies.id = inventory_transfers.store_id_from ",
#                    :conditions => [" (store_id_to = ?) AND
#                                    (issued_trans_bk  = 'IS01') AND
#                                    (status  = 'T') AND
#                                    (companies.company_cd between ? and ? AND (0 =? or companies.company_cd in (?))) AND
#                                    (account_period_code between ? and ? AND (0 =? or account_period_code in (?))) AND
#                                    (issued_trans_no between ? and ? AND (0 =? or received_trans_no in (?))) AND
#                                    (catalog_items.store_code between ? and ? AND (0 =? or catalog_items.store_code in (?)))
#                                    " ,criteria.company_id,
#                                       criteria.str1,     criteria.str2,     criteria.multiselect1.length, criteria.multiselect1,
#                                       criteria.str3[0,8],criteria.str4[0,8],criteria.multiselect2.length, criteria.multiselect2,
#                                       criteria.str5, criteria.str6,criteria.multiselect3.length, criteria.multiselect3,
#                                       criteria.str7, criteria.str8,criteria.multiselect4.length, criteria.multiselect4], 
#                    :order => "issued_trans_date, issued_trans_no"
#  )
  Inventory::InventoryTransfer.find_by_sql ["select CAST( (select(select inventory_transfers.* from inventory_transfers
                                          join catalog_items on catalog_items.id = inventory_transfers.catalog_item_id 
                                          join companies on companies.id = inventory_transfers.store_id_from
                                          where inventory_transfers.trans_flag = 'A' AND
                                          (store_id_to = ?) AND
                                          (issued_trans_bk  = 'IS01') AND
                                          (status  = 'T') AND
                                          (companies.company_cd between ? and ? AND (0 =? or companies.company_cd in (?))) AND
                                          (account_period_code between ? and ? AND (0 =? or account_period_code in (?))) AND
                                          (issued_trans_no between ? and ? AND (0 =? or received_trans_no in (?))) AND
                                          (catalog_items.store_code between ? and ? AND (0 =? or catalog_items.store_code in (?)))
                                          order by inventory_transfers.issued_trans_date, inventory_transfers.issued_trans_no 
                                          FOR XML PATH('inventory_transfer'),type,elements xsinil)FOR XML PATH('inventory_transfers')) AS xml) as XMLCOL ",
                                          criteria.company_id,
                                          criteria.str1,     criteria.str2,     criteria.multiselect1.length, criteria.multiselect1,
                                          criteria.str3[0,8],criteria.str4[0,8],criteria.multiselect2.length, criteria.multiselect2,
                                          criteria.str5, criteria.str6,criteria.multiselect3.length, criteria.multiselect3,
                                          criteria.str7, criteria.str8,criteria.multiselect4.length, criteria.multiselect4
                                ]
end

#                                    (issued_trans_date between ? and ? ) AND
#                                      criteria.dt1,      criteria.dt2,
 

def self.show_inventory_transfer(inventory_transfer_id)
  Inventory::InventoryTransfer.find_all_by_id(inventory_transfer_id)
end

def self.post_inventory_transfers(transfer_date, store_id_from, store_id_to, inventory_postings)  
  trans_bk = inventory_postings.first.trans_bk 
  trans_no = inventory_postings.first.trans_no 
  company_id = inventory_postings.first.company_id
  destroy_inventory_transfers(trans_bk,trans_no,company_id) 
  build_inventory_transfers(transfer_date, store_id_from, store_id_to, inventory_postings) 
end

def self.destroy_inventory_transfers(trans_bk,trans_no,company_id)
  #inventory_transfers = Inventory::InventoryTransfer.find_all_by_issued_trans_bk_and_issued_trans_no_and_com(trans_bk,trans_no,company_id)
  inventory_transfers = Inventory::InventoryTransfer.active.find(:all,
                    :conditions => [" (company_id=?) AND
                                    (issued_trans_bk  = ?) AND
                                    (issued_trans_no = ?)
                                    " ,company_id,trans_bk,trans_no]
  )
  inventory_transfers.each{|li| li.destroy }
end

def self.build_inventory_transfers(transfer_date, store_id_from, store_id_to, inventory_postings) 
  inventory_postings.each{|inventory_posting|
      inventory_transfer = Inventory::InventoryTransfer.new
#      fill_inventory_transfer(inventory_transfer) 
      inventory_transfer.transfer_date = transfer_date
      inventory_transfer.store_id_from = store_id_from
      inventory_transfer.store_id_to = store_id_to
      inventory_transfer.company_id = store_id_to
      inventory_transfer.issued_trans_bk = inventory_posting.trans_bk if inventory_posting.trans_bk
      inventory_transfer.issued_trans_no = inventory_posting.trans_no if inventory_posting.trans_no
      inventory_transfer.issued_trans_date = transfer_date
      inventory_transfer.issued_serial_no = inventory_posting.serial_no if inventory_posting.serial_no
      inventory_transfer.account_period_code = inventory_posting.account_period_code if inventory_posting.account_period_code
      inventory_transfer.catalog_item_id = inventory_posting.catalog_item_id if inventory_posting.catalog_item_id
      inventory_transfer.catalog_item_packet_id = inventory_posting.catalog_item_packet_id if inventory_posting.catalog_item_packet_id
      inventory_transfer.catalog_item_code = inventory_posting.catalog_item_code if inventory_posting.catalog_item_code
      inventory_transfer.catalog_item_packet_code = inventory_posting.catalog_item_packet_code if inventory_posting.catalog_item_packet_code
      inventory_transfer.item_description = inventory_posting.item_description if inventory_posting.item_description
      inventory_transfer.transfer_qty = nulltozero(inventory_posting.stock_iss_qty) if inventory_posting.stock_iss_qty 
      inventory_transfer.transfer_price = nulltozero(inventory_posting.stock_iss_price) if inventory_posting.stock_iss_price
      inventory_transfer.transfer_amt = nulltozero(inventory_posting.stock_iss_amt) if inventory_posting.stock_iss_amt
      inventory_transfer.status='T' #in-transit
      inventory_transfer.save!
  }  
end 

def self.create_inventory_transfers(doc)
 inventory_transfers = [] 
 (doc/:inventory_transfers/:inventory_transfer).each{|transfer_doc|
   inventory_transfer = create_inventory_transfer(transfer_doc)
   inventory_transfers <<  inventory_transfer if inventory_transfer
  }
  Inventory::InventoryTransactionCrud.post_receive_transaction(inventory_transfers)
  inventory_transfers
end

def self.create_inventory_transfer(doc)
  inventory_transfer = add_or_modify_inventory_transfer(doc) 
  return  if !inventory_transfer
  save_proc = Proc.new{
    inventory_transfer.save!  
}
  inventory_transfer.save_transaction(&save_proc)
  return inventory_transfer
end

def self.add_or_modify_inventory_transfer(doc)  
  id =  parse_xml(doc/'id') if (doc/'id').first  
  inventory_transfer = Inventory::InventoryTransfer.find_or_create(id) 
  return if !inventory_transfer
  if !inventory_transfer.new_record? and inventory_transfer.update_flag == 'V'
    inventory_transfer.errors.add('','This transfer is View Only. Cannot update.') 
    return inventory_transfer
  end
  inventory_transfer.apply_attributes(doc) 
  inventory_transfer.status = 'R'
  return inventory_transfer 
end

private_class_method :create_inventory_transfer, :add_or_modify_inventory_transfer

end
