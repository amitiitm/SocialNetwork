class Inventory::InventoryStageSummaryPosting < ActiveRecord::BaseWithoutTable
  include General
  include ClassMethods

  attr_accessor :company_id
  attr_accessor :update_flag
  attr_accessor :account_period_code
  attr_accessor :catalog_item_id
  attr_accessor :catalog_item_code
  attr_accessor :catalog_item_packet_id
  attr_accessor :catalog_item_packet_code
#  attr_accessor :catalog_item_batch_id
  attr_accessor :catalog_item_batch_code
  attr_accessor :transaction_bom_id
  attr_accessor :transaction_bom_types
  attr_accessor :stage_code
  attr_accessor :stage_qty
  attr_accessor :old_item_qty
  attr_accessor :clear_qty
  attr_accessor :trans_flag
  attr_accessor :ri_flag
  attr_accessor :unpost_flag
  attr_accessor :trans_bk
  attr_accessor :trans_no
  #  def self.post_inventory_stages(inventory_postings)
  #    unpost_inventory(inventory_postings)
  #    post_inventory_detail(inventory_postings)
  #  end
  #
  #  def self.unpost_inventory(inventory_postings)
  #    inventory_postings.each{|posting|
  #      inventory_stage_lines = Inventory::InventoryStageDetail.find_all_by_catalog_item_id_and_catalog_item_packet_id_and_stage_code_and_transaction_bom_id(posting.catalog_item_id,posting.catalog_item_packet_id,posting.stage_code,posting.transaction_bom_id)
  #      inventory_stage_lines.each{|li| li.destroy }
  #    }
  #  end
  #
  #  def self.post_inventory_detail(inventory_postings)
  #    inventory_postings.each{|li|
  #      inventory = Inventory::InventoryStageDetail.new
  #      li.post_detail(inventory)
  #      inventory.save!
  #    }
  #  end
  #
  #  def post_detail(inventory)
  #    inventory.company_id = self.company_id if self.company_id
  #    inventory.update_flag = 'V'
  #    inventory.company_id = self.company_id if self.company_id
  #    inventory.catalog_item_id = self.catalog_item_id if self.catalog_item_id
  #    inventory.catalog_item_packet_id = self.catalog_item_packet_id if self.catalog_item_packet_id
  #    inventory.catalog_item_code = self.catalog_item_code if self.catalog_item_code
  #    inventory.catalog_item_packet_code = self.catalog_item_packet_code if self.catalog_item_packet_code
  #    inventory.catalog_item_batch_id = self.catalog_item_batch_id if self.catalog_item_batch_id
  #    inventory.catalog_item_batch_code = self.catalog_item_batch_code if self.catalog_item_batch_code
  #    inventory.transaction_bom_id = self.transaction_bom_id if self.transaction_bom_id
  #    inventory.transaction_bom_types = self.transaction_bom_types if self.transaction_bom_types
  #    inventory.trans_flag = self.trans_flag if self.trans_flag
  #    inventory.stage_code = self.stage_code if self.stage_code
  #    inventory.stage_qty = self.stage_qty if self.stage_qty
  #    inventory.clear_qty = self.clear_qty if self.clear_qty
  #  end
  #
  #  def self.post_summary(account_period_code,company_id,inventory_postings)
  #    posted_summaries = []
  #    inventory_items = list_of_inventory_items(inventory_postings).uniq
  #    inventory_items.each{|inventory_item|
  #      catalog_item_id, catalog_item_packet_id = split_ids(inventory_item)
  #      inventory_item_lines = inventory_postings.to_ary.find_all{|li| li.catalog_item_id == catalog_item_id and (li.catalog_item_packet_id == catalog_item_packet_id)}
  #      total_memo_iss_qty = total_memo_iss_qty(inventory_item_lines)
  #      total_memo_iss_amt = total_memo_iss_amt(inventory_item_lines)
  #      total_memo_rec_qty  = total_memo_rec_qty(inventory_item_lines)
  #      total_memo_rec_amt  = total_memo_rec_amt(inventory_item_lines)
  #      total_stock_iss_qty = total_stock_iss_qty(inventory_item_lines)
  #      total_stock_iss_amt = total_stock_iss_amt(inventory_item_lines)
  #      total_stock_rec_qty = total_stock_rec_qty(inventory_item_lines)
  #      total_stock_rec_amt = total_stock_rec_amt(inventory_item_lines)
  #      #    if catalog_item_packet_id == 0
  #      #      inventory_summary = Inventory::InventorySummary.find_by_account_period_code_and_company_id_and_catalog_item_id(account_period_code,company_id,catalog_item_id)
  #      #    else
  #      #      inventory_summary = Inventory::InventorySummary.find_by_account_period_code_and_company_id_and_catalog_item_id_and_catalog_item_packet_id(account_period_code,company_id,catalog_item_id,catalog_item_packet_id)
  #      #    end
  #      inventory_summary = Inventory::InventorySummary.find( :first,
  #        :conditions => ["account_period_code = ? and company_id = ? and
  #                                                            catalog_item_id = ? and ( catalog_item_packet_id = ?)
  #          ",account_period_code,company_id,
  #          catalog_item_id,catalog_item_packet_id]
  #      )
  #      if inventory_summary
  #        inventory_summary.memo_iss_qty += total_memo_iss_qty
  #        inventory_summary.memo_iss_amt += total_memo_iss_amt
  #        inventory_summary.memo_rec_qty += total_memo_rec_qty
  #        inventory_summary.memo_rec_amt += total_memo_rec_amt
  #        inventory_summary.stock_iss_qty += total_stock_iss_qty
  #        inventory_summary.stock_iss_amt += total_stock_iss_amt
  #        inventory_summary.stock_rec_qty += total_stock_rec_qty
  #        inventory_summary.stock_rec_amt += total_stock_rec_amt
  #        inventory_summary.post_flag = 'P'
  #      else
  #        inventory_summary = Inventory::InventorySummary.new
  #        inventory_summary.account_period_code = account_period_code
  #        inventory_summary.company_id = company_id
  #        inventory_summary.catalog_item_id = catalog_item_id
  #        inventory_summary.catalog_item_packet_id = catalog_item_packet_id
  #        inventory_summary.memo_iss_qty = total_memo_iss_qty
  #        inventory_summary.memo_iss_amt = total_memo_iss_amt
  #        inventory_summary.memo_rec_qty = total_memo_rec_qty
  #        inventory_summary.memo_rec_amt = total_memo_rec_amt
  #        inventory_summary.stock_iss_qty = total_stock_iss_qty
  #        inventory_summary.stock_iss_amt = total_stock_iss_amt
  #        inventory_summary.stock_rec_qty = total_stock_rec_qty
  #        inventory_summary.stock_rec_amt = total_stock_rec_amt
  #        inventory_summary.post_flag = 'P'
  #      end
  #      posted_summaries << inventory_summary
  #    }
  #
  #    posted_summaries.each{|summ|  summ.save!}
  #  end
  #
  #  
  #
  #  def self.total_stage_qty(inventory_item_lines)
  #    return inventory_item_lines.inject(0){|sum,x| sum += nulltozero(x.stage_qty) } if inventory_item_lines
  #  end
  #
  #  def self.total_clear_qty(inventory_item_lines)
  #    return inventory_item_lines.inject(0){|sum,x| sum += nulltozero(x.clear_qty) } if inventory_item_lines
  #  end

  def self.post_inventory_stages(inventory_postings)  
    company_id = inventory_postings.first.company_id
    unpost_inventory(company_id,inventory_postings) 
    #    post_inventory_detail(inventory_postings) 
    post_summary(company_id,inventory_postings)
  end

  def self.unpost_inventory(company_id,inventory_postings)  
    unposted_summaries = []
    inventory_postings.each{|posting_line|
      inventory_details = Inventory::InventoryStageSummary.find_all_by_catalog_item_id_and_catalog_item_packet_id_and_company_id(posting_line.catalog_item_id,posting_line.catalog_item_packet_id,company_id)
      inventory_items = list_of_inventory_items(inventory_details).uniq
      inventory_items.each{|inventory_item|
        catalog_item_id, catalog_item_packet_id ,catalog_item_code,catalog_item_packet_code,transaction_bom_id,transaction_bom_types,trans_flag,stage_code,stage_qty,clear_qty , ri_flag = split_ids(inventory_item)  #newly add for batch id
        inventory_item_lines = inventory_details.to_ary.find_all{|li| li.catalog_item_id == catalog_item_id and (li.catalog_item_packet_id == catalog_item_packet_id  or catalog_item_packet_id == 0 ) }  #newly add for batch id
        total_stage_qty = total_stage_qty(inventory_item_lines)
        total_clear_qty = total_clear_qty(inventory_item_lines)
        inventory_summary = Inventory::InventoryStageSummary.find( :first,
          :conditions => ["company_id = ? and catalog_item_id = ? and ( catalog_item_packet_id = ? or ? = 0 ) 
            ",company_id,catalog_item_id,catalog_item_packet_id,catalog_item_packet_id]  #newly added for batch id
        )
        if inventory_summary
          #          inventory_summary.stage_qty -= total_stage_qty
          #          inventory_summary.clear_qty -= total_clear_qty
          inventory_summary.stage_qty = nulltozero(total_stage_qty) - nulltozero(posting_line.old_item_qty) if (inventory_postings[0].ri_flag=='R' and posting_line.unpost_flag =='Y')
          inventory_summary.clear_qty = nulltozero(total_clear_qty) - nulltozero(posting_line.old_item_qty) if (inventory_postings[0].ri_flag=='I'and posting_line.unpost_flag =='Y')
          inventory_summary.catalog_item_id = catalog_item_id
          inventory_summary.catalog_item_packet_id = catalog_item_packet_id
          inventory_summary.catalog_item_code = catalog_item_code
          inventory_summary.catalog_item_packet_code =catalog_item_packet_code
          inventory_summary.transaction_bom_id = transaction_bom_id
          inventory_summary.transaction_bom_types = transaction_bom_types
          inventory_summary.trans_flag = trans_flag
          inventory_summary.stage_code = stage_code
          unposted_summaries << inventory_summary
        end
      }
    }
    unposted_summaries.each{|summ|  summ.save!}
    #    unposted_summaries
  
  end
 
  def self.post_summary(company_id,inventory_postings) 
    posted_summaries = []
    inventory_items = list_of_inventory_items(inventory_postings).uniq
    inventory_items.each{|inventory_item|
      catalog_item_id, catalog_item_packet_id,catalog_item_code,catalog_item_packet_code,transaction_bom_id,transaction_bom_types,trans_flag,stage_code,stage_qty,clear_qty,ri_flag = split_ids(inventory_item)
      inventory_item_lines = inventory_postings.to_ary.find_all{|li| li.catalog_item_id == catalog_item_id and (li.catalog_item_packet_id == catalog_item_packet_id)} 
      total_stage_qty = total_stage_qty(inventory_item_lines)
      total_clear_qty = total_clear_qty(inventory_item_lines)
      inventory_summary = Inventory::InventoryStageSummary.find( :first,
        :conditions => ["company_id = ? and catalog_item_id = ? and ( catalog_item_packet_id = ?)  
          ",company_id,catalog_item_id,catalog_item_packet_id]  
      )
      if inventory_summary
        #        inventory_summary.stage_qty += total_stage_qty
        #        inventory_summary.clear_qty += total_clear_qty
        inventory_summary.stage_qty += nulltozero(total_stage_qty) if inventory_postings[0].ri_flag=='R'
        inventory_summary.clear_qty += nulltozero(total_clear_qty) if inventory_postings[0].ri_flag=='I'
        inventory_summary.catalog_item_id = catalog_item_id
        inventory_summary.catalog_item_packet_id = catalog_item_packet_id
        inventory_summary.catalog_item_code = catalog_item_code
        inventory_summary.catalog_item_packet_code =catalog_item_packet_code
        inventory_summary.transaction_bom_id = transaction_bom_id
        inventory_summary.transaction_bom_types = transaction_bom_types
        inventory_summary.trans_flag = trans_flag
        inventory_summary.stage_code = stage_code
      else
        inventory_summary = Inventory::InventoryStageSummary.new
        inventory_summary.company_id = company_id
        inventory_summary.catalog_item_id = catalog_item_id
        inventory_summary.catalog_item_packet_id = catalog_item_packet_id
        inventory_summary.catalog_item_code = catalog_item_code
        inventory_summary.catalog_item_packet_code =catalog_item_packet_code
        inventory_summary.transaction_bom_id = transaction_bom_id
        inventory_summary.transaction_bom_types = transaction_bom_types
        inventory_summary.trans_flag = trans_flag
        inventory_summary.stage_code = stage_code
        inventory_summary.stage_qty = total_stage_qty
        inventory_summary.clear_qty = total_clear_qty
      end
      posted_summaries << inventory_summary
    }
    
    posted_summaries.each{|summ|  summ.save!}
  end

  def self.list_of_inventory_items(inventory_postings)
    return inventory_postings.inject([]){|inventory_items,li| inventory_items << "#{li.catalog_item_id},#{li.catalog_item_packet_id},#{li.catalog_item_code},#{li.catalog_item_packet_code},#{li.transaction_bom_id},#{li.transaction_bom_types},#{li.trans_flag},#{li.stage_code},#{li.stage_qty},#{li.clear_qty}"}  
  end

 
  def self.total_stage_qty(inventory_item_lines)
    return inventory_item_lines.inject(0){|sum,x| sum += nulltozero(x.stage_qty) } if inventory_item_lines
  end
  
  def self.total_clear_qty(inventory_item_lines)
    return inventory_item_lines.inject(0){|sum,x| sum += nulltozero(x.clear_qty) } if inventory_item_lines
  end
  
  
  def self.split_ids(inventory_item)
    splitted_array = inventory_item.split(',') 
    catalog_item_id = splitted_array[0]
    catalog_item_packet_id = splitted_array[1]

    catalog_item_code = splitted_array[3]
    catalog_item_packet_code = splitted_array[4]

    transaction_bom_id = splitted_array[6]
    transaction_bom_types = splitted_array[7]
    trans_flag = splitted_array[8]
    stage_code = splitted_array[9]
    stage_qty = splitted_array[10]
    clear_qty = splitted_array[11]
    ri_flag = splitted_array[12]
    return catalog_item_id.to_i, catalog_item_packet_id.to_i ,catalog_item_batch_id.to_i,catalog_item_code,catalog_item_packet_code,catalog_item_batch_code,transaction_bom_id,transaction_bom_types,trans_flag,stage_code,stage_qty.to_i,clear_qty.to_i,ri_flag
  end


end
