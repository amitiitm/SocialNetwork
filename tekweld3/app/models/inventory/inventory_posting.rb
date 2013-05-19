class Inventory::InventoryPosting < ActiveRecord::BaseWithoutTable
  include General
  include ClassMethods

  attr_accessor :company_id
  attr_accessor :update_flag
  attr_accessor :trans_bk
  attr_accessor :trans_no
  attr_accessor :trans_date
  attr_accessor :serial_no
  attr_accessor :account_period_code
  attr_accessor :trans_type
  attr_accessor :trans_type_id
  attr_accessor :ext_ref_no
  attr_accessor :ext_ref_date
  attr_accessor :catalog_item_id
  attr_accessor :catalog_item_packet_id
  attr_accessor :receipt_issue_flag
  attr_accessor :stock_rec_qty
  attr_accessor :stock_iss_qty
  attr_accessor :memo_rec_qty
  attr_accessor :memo_iss_qty
  attr_accessor :stock_rec_price
  attr_accessor :stock_iss_price
  attr_accessor :memo_rec_price
  attr_accessor :memo_iss_price
  attr_accessor :stock_rec_amt
  attr_accessor :stock_iss_amt
  attr_accessor :memo_rec_amt
  attr_accessor :memo_iss_amt
  attr_accessor :catalog_item_code
  attr_accessor :catalog_item_packet_code
  attr_accessor :item_description
  attr_accessor :trans_flag
  #  attr_accessor :catalog_item_batch_id   #newly added for batch id

  def self.post_inventory_transactions(inventory_postings)  
    trans_bk = inventory_postings.first.trans_bk 
    trans_no = inventory_postings.first.trans_no 
    account_period_code = inventory_postings.first.account_period_code
    company_id = inventory_postings.first.company_id
    unpost_inventory(trans_bk,trans_no,account_period_code,company_id) 
    post_inventory_detail(inventory_postings)
    post_summary(account_period_code,company_id,inventory_postings)
  end

  def self.unpost_inventory(trans_bk,trans_no,account_period_code,company_id)  
    unposted_summaries = []
    inventory_details = Inventory::InventoryDetail.find_all_by_trans_bk_and_trans_no_and_company_id(trans_bk,trans_no,company_id)
    inventory_items = list_of_inventory_items(inventory_details).uniq
    inventory_items.each{|inventory_item|
      #      catalog_item_id, catalog_item_packet_id = split_ids(inventory_item) 
      catalog_item_id, catalog_item_packet_id  = split_ids(inventory_item)  #newly add for batch id
      #      inventory_item_lines = inventory_details.to_ary.find_all{|li| li.catalog_item_id == catalog_item_id and (li.catalog_item_packet_id == catalog_item_packet_id  or catalog_item_packet_id == 0 ) }
      inventory_item_lines = inventory_details.to_ary.find_all{|li| li.catalog_item_id == catalog_item_id and (li.catalog_item_packet_id == catalog_item_packet_id  or catalog_item_packet_id == 0 ) }
      total_memo_iss_qty = total_memo_iss_qty(inventory_item_lines)
      total_memo_iss_amt = total_memo_iss_amt(inventory_item_lines)
      total_memo_rec_qty  = total_memo_rec_qty(inventory_item_lines)
      total_memo_rec_amt  = total_memo_rec_amt(inventory_item_lines)
      total_stock_iss_qty = total_stock_iss_qty(inventory_item_lines)
      total_stock_iss_amt = total_stock_iss_amt(inventory_item_lines)
      total_stock_rec_qty = total_stock_rec_qty(inventory_item_lines)
      total_stock_rec_amt = total_stock_rec_amt(inventory_item_lines)
      inventory_summary = Inventory::InventorySummary.find( :first,
        :conditions => ["account_period_code = ? and company_id = ? and
                                                            catalog_item_id = ? and ( catalog_item_packet_id = ? or ? = 0 ) 
                                                     
          ",inventory_details[0].account_period_code,company_id,
          catalog_item_id,catalog_item_packet_id,catalog_item_packet_id]  
      )
      if inventory_summary
        inventory_summary.memo_iss_qty -= total_memo_iss_qty
        inventory_summary.memo_iss_amt -= total_memo_iss_amt
        inventory_summary.memo_rec_qty -= total_memo_rec_qty
        inventory_summary.memo_rec_amt -= total_memo_rec_amt
        inventory_summary.stock_iss_qty -= total_stock_iss_qty
        inventory_summary.stock_iss_amt -= total_stock_iss_amt
        inventory_summary.stock_rec_qty -= total_stock_rec_qty
        inventory_summary.stock_rec_amt -= total_stock_rec_amt
        inventory_summary.post_flag = 'U'
        unposted_summaries << inventory_summary
      end
    }
    unposted_summaries.each{|summ|  summ.save!}
    #Unpost inventory detail.
    inventory_details.each{|li| li.destroy }
  end

  def self.post_inventory_detail(inventory_postings) 
    inventory_postings.each{|li|
      inventory = Inventory::InventoryDetail.new
      li.post_detail(inventory) 
      inventory.save!
    }  
  end 

  def post_detail(inventory)
    inventory.company_id = self.company_id if self.company_id
    inventory.trans_bk = self.trans_bk if self.trans_bk
    inventory.trans_no = self.trans_no if self.trans_no
    inventory.trans_date = self.trans_date if self.trans_date
    inventory.serial_no = self.serial_no if self.serial_no
    inventory.update_flag = 'V'
    inventory.account_period_code = self.account_period_code if self.account_period_code
    inventory.company_id = self.company_id if self.company_id
    inventory.trans_type = self.trans_type if self.trans_type
    inventory.trans_type_id = self.trans_type_id if self.trans_type_id
    inventory.ext_ref_no = self.ext_ref_no if self.ext_ref_no
    inventory.ext_ref_date = self.ext_ref_date if self.ext_ref_date
    inventory.catalog_item_id = self.catalog_item_id if self.catalog_item_id
    inventory.catalog_item_packet_id = self.catalog_item_packet_id if self.catalog_item_packet_id
    inventory.receipt_issue_flag = self.receipt_issue_flag if self.receipt_issue_flag
    inventory.memo_iss_qty = nulltozero(self.memo_iss_qty) if self.memo_iss_qty
    inventory.memo_iss_price = nulltozero(self.memo_iss_price) if self.memo_iss_price
    inventory.memo_iss_amt = nulltozero(self.memo_iss_amt) if self.memo_iss_amt
    inventory.memo_rec_qty = nulltozero(self.memo_rec_qty) if self.memo_rec_qty 
    inventory.memo_rec_price = nulltozero(self.memo_rec_price) if self.memo_rec_price
    inventory.memo_rec_amt = nulltozero(self.memo_rec_amt) if self.memo_rec_amt
    inventory.stock_iss_qty = nulltozero(self.stock_iss_qty) if self.stock_iss_qty 
    inventory.stock_iss_price = nulltozero(self.stock_iss_price) if self.stock_iss_price
    inventory.stock_iss_amt = nulltozero(self.stock_iss_amt) if self.stock_iss_amt
    inventory.stock_rec_qty = nulltozero(self.stock_rec_qty) if self.stock_rec_qty
    inventory.stock_rec_price = nulltozero(self.stock_rec_price) if self.stock_rec_price
    inventory.stock_rec_amt = nulltozero(self.stock_rec_amt) if self.stock_rec_amt
    inventory.trans_flag=self.trans_flag if self.trans_flag
    
  end

  def self.post_summary(account_period_code,company_id,inventory_postings) 
    posted_summaries = []
    inventory_items = list_of_inventory_items(inventory_postings).uniq
    inventory_items.each{|inventory_item|
      #      catalog_item_id, catalog_item_packet_id = split_ids(inventory_item)
      catalog_item_id, catalog_item_packet_id  = split_ids(inventory_item)
      #      inventory_item_lines = inventory_postings.to_ary.find_all{|li| li.catalog_item_id == catalog_item_id and (li.catalog_item_packet_id == catalog_item_packet_id)}
      inventory_item_lines = inventory_postings.to_ary.find_all{|li| li.catalog_item_id == catalog_item_id and (li.catalog_item_packet_id == catalog_item_packet_id) } #newly added for batch id
      total_memo_iss_qty = total_memo_iss_qty(inventory_item_lines)
      total_memo_iss_amt = total_memo_iss_amt(inventory_item_lines)
      total_memo_rec_qty  = total_memo_rec_qty(inventory_item_lines)
      total_memo_rec_amt  = total_memo_rec_amt(inventory_item_lines)
      total_stock_iss_qty = total_stock_iss_qty(inventory_item_lines)
      total_stock_iss_amt = total_stock_iss_amt(inventory_item_lines)
      total_stock_rec_qty = total_stock_rec_qty(inventory_item_lines)
      total_stock_rec_amt = total_stock_rec_amt(inventory_item_lines)
      #    if catalog_item_packet_id == 0
      #      inventory_summary = Inventory::InventorySummary.find_by_account_period_code_and_company_id_and_catalog_item_id(account_period_code,company_id,catalog_item_id)
      #    else
      #      inventory_summary = Inventory::InventorySummary.find_by_account_period_code_and_company_id_and_catalog_item_id_and_catalog_item_packet_id(account_period_code,company_id,catalog_item_id,catalog_item_packet_id)
      #    end
      inventory_summary = Inventory::InventorySummary.find( :first,
        :conditions => ["account_period_code = ? and company_id = ? and
                                                            catalog_item_id = ? and ( catalog_item_packet_id = ?) 
          ",account_period_code,company_id,
          catalog_item_id,catalog_item_packet_id]   #newly added for batch id
      )
      if inventory_summary
        inventory_summary.memo_iss_qty += total_memo_iss_qty
        inventory_summary.memo_iss_amt += total_memo_iss_amt
        inventory_summary.memo_rec_qty += total_memo_rec_qty
        inventory_summary.memo_rec_amt += total_memo_rec_amt
        inventory_summary.stock_iss_qty += total_stock_iss_qty
        inventory_summary.stock_iss_amt += total_stock_iss_amt
        inventory_summary.stock_rec_qty += total_stock_rec_qty
        inventory_summary.stock_rec_amt += total_stock_rec_amt
        inventory_summary.post_flag = 'P'
      else
        inventory_summary = Inventory::InventorySummary.new
        inventory_summary.account_period_code = account_period_code
        inventory_summary.company_id = company_id
        inventory_summary.catalog_item_id = catalog_item_id
        inventory_summary.catalog_item_packet_id = catalog_item_packet_id
        inventory_summary.memo_iss_qty = total_memo_iss_qty
        inventory_summary.memo_iss_amt = total_memo_iss_amt
        inventory_summary.memo_rec_qty = total_memo_rec_qty
        inventory_summary.memo_rec_amt = total_memo_rec_amt
        inventory_summary.stock_iss_qty = total_stock_iss_qty
        inventory_summary.stock_iss_amt = total_stock_iss_amt
        inventory_summary.stock_rec_qty = total_stock_rec_qty
        inventory_summary.stock_rec_amt = total_stock_rec_amt
        inventory_summary.post_flag = 'P'
      end
      posted_summaries << inventory_summary
    }
    
    posted_summaries.each{|summ|  summ.save!}
  end

  def self.list_of_inventory_items(inventory_postings)
    return inventory_postings.inject([]){|inventory_items,li| inventory_items << "#{li.catalog_item_id},#{li.catalog_item_packet_id}"} 
  end

  def self.total_memo_iss_qty(inventory_item_lines)
    return inventory_item_lines.inject(0){|sum,x| sum += nulltozero(x.memo_iss_qty) } if inventory_item_lines
  end

  def self.total_memo_iss_amt(inventory_item_lines)
    return inventory_item_lines.inject(0){|sum,x| sum += nulltozero(x.memo_iss_amt) } if inventory_item_lines
  end

  def self.total_memo_rec_qty(inventory_item_lines)
    return inventory_item_lines.inject(0){|sum,x| sum += nulltozero(x.memo_rec_qty) } if inventory_item_lines
  end

  def self.total_memo_rec_amt(inventory_item_lines)
    return inventory_item_lines.inject(0){|sum,x| sum += nulltozero(x.memo_rec_amt) } if inventory_item_lines
  end

  def self.total_stock_iss_qty(inventory_item_lines)
    return inventory_item_lines.inject(0){|sum,x| sum += nulltozero(x.stock_iss_qty) } if inventory_item_lines
  end

  def self.total_stock_iss_amt(inventory_item_lines)
    return inventory_item_lines.inject(0){|sum,x| sum += nulltozero(x.stock_iss_amt) } if inventory_item_lines
  end

  def self.total_stock_rec_qty(inventory_item_lines)
    return inventory_item_lines.inject(0){|sum,x| sum += nulltozero(x.stock_rec_qty) } if inventory_item_lines
  end

  def self.total_stock_rec_amt(inventory_item_lines)
    return inventory_item_lines.inject(0){|sum,x| sum += nulltozero(x.stock_rec_amt) } if inventory_item_lines
  end

  def self.split_ids(inventory_item)
    #    catalog_item_id = inventory_item[0,inventory_item.rindex(',')]
    #    catalog_item_packet_id = inventory_item[inventory_item.rindex(',')+1,inventory_item.length]
    #    return catalog_item_id.to_i, catalog_item_packet_id.to_i
    splitted_array = inventory_item.split(',')  #newly added for batch id
    catalog_item_id = splitted_array[0]
    catalog_item_packet_id = splitted_array[1]
    return catalog_item_id.to_i, catalog_item_packet_id.to_i 
  end

end
