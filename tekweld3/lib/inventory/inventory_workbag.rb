module Inventory::InventoryWorkbag

  class Posting
    include General
    include ClassMethods
    def create_inventory_postings(object)
      curr_lines = identify_post_lines(object)
      inventory_postings = []
      curr_lines.each{|curr_line|
        account_period_code = curr_line.account_period_code
        trans_type = 'C'
        trans_type_id = object.customer_id
        ext_ref_no = object.ext_ref_no
        ext_ref_date = object.ext_ref_date
        catalog_item_id = curr_line.catalog_item_id
        catalog_item_packet_id = nulltozero(curr_line.catalog_item_packet_id)
        item_qty = curr_line.qty
        item_price = curr_line.price
        net_amt = curr_line.total_amt
        trans_bk = curr_line.trans_bk
        trans_no = curr_line.trans_no
        company_id = curr_line.company_id
        trans_date = curr_line.trans_date
        serial_no = curr_line.serial_no
        trans_flag = curr_line.trans_flag
        inventory_posting = fill_inventory_posting(account_period_code, catalog_item_id, catalog_item_packet_id, 
          item_qty, item_price, net_amt, trans_bk, trans_no,company_id,trans_date,serial_no,trans_type,trans_type_id,ext_ref_no,ext_ref_date,trans_flag)
        inventory_postings << inventory_posting
      }
      inventory_postings
    end 

    def fill_inventory_posting(account_period_code, catalog_item_id, catalog_item_packet_id, item_qty, item_price, net_amt, trans_bk, trans_no,company_id,trans_date,serial_no,trans_type,trans_type_id,ext_ref_no,ext_ref_date,trans_flag)
      inventory_posting = Inventory::InventoryPosting.new
      inventory_posting.trans_bk = trans_bk
      inventory_posting.trans_no = trans_no
      inventory_posting.company_id = company_id
      inventory_posting.trans_date = trans_date
      inventory_posting.serial_no = serial_no
      inventory_posting.update_flag = 'V'
      inventory_posting.account_period_code = account_period_code
      inventory_posting.trans_type = trans_type
      inventory_posting.trans_type_id = trans_type_id
      inventory_posting.ext_ref_no = ext_ref_no
      inventory_posting.ext_ref_date = ext_ref_date
      inventory_posting.catalog_item_id = catalog_item_id
      inventory_posting.catalog_item_packet_id = catalog_item_packet_id
      inventory_posting.trans_flag = trans_flag      
      inventory_posting.stock_iss_qty = item_qty 
      inventory_posting.stock_iss_price = item_price
      inventory_posting.stock_iss_amt = net_amt
      inventory_posting.receipt_issue_flag = 'I'
      inventory_posting
    end

    def identify_post_lines(object)
      case object.class.name
      when 'Production::Workbag'
        object_lines = object.workbag_item_issues
      else
      end
      return object_lines
    end

    
    def create_inventory_posting_for_workbag(object,inventory_postings)
      #      inventory_postings = []
      account_period_code = object.account_period_code
      trans_type = 'C'
      trans_type_id = object.customer_id
      ext_ref_no = object.ext_ref_no
      ext_ref_date = object.ext_ref_date
      catalog_item_id = object.catalog_item_id
      catalog_item_packet_id = nulltozero(object.catalog_item_packet_id)
      item_qty = object.wb_qty
      item_price = object.item_price
      net_amt = 100
      trans_bk = object.trans_bk
      trans_no = object.trans_no
      company_id = object.company_id
      trans_date = object.trans_date
      serial_no = 101
      trans_flag = object.trans_flag
      inventory_posting = fill_inventory_posting_for_workbag(account_period_code, catalog_item_id, catalog_item_packet_id, 
        item_qty, item_price, net_amt, trans_bk, trans_no,company_id,trans_date,serial_no,trans_type,trans_type_id,ext_ref_no,ext_ref_date,trans_flag)
      inventory_postings << inventory_posting
    
      inventory_postings
    end 

    def fill_inventory_posting_for_workbag(account_period_code, catalog_item_id, catalog_item_packet_id, item_qty, item_price, net_amt, trans_bk, trans_no,company_id,trans_date,serial_no,trans_type,trans_type_id,ext_ref_no,ext_ref_date,trans_flag)
      inventory_posting = Inventory::InventoryPosting.new
      inventory_posting.trans_bk = trans_bk
      inventory_posting.trans_no = trans_no
      inventory_posting.company_id = company_id
      inventory_posting.trans_date = trans_date
      inventory_posting.serial_no = serial_no
      inventory_posting.update_flag = 'V'
      inventory_posting.account_period_code = account_period_code
      inventory_posting.trans_type = trans_type
      inventory_posting.trans_type_id = trans_type_id
      inventory_posting.ext_ref_no = ext_ref_no
      inventory_posting.ext_ref_date = ext_ref_date
      inventory_posting.catalog_item_id = catalog_item_id
      inventory_posting.catalog_item_packet_id = catalog_item_packet_id
      inventory_posting.trans_flag = trans_flag      
      inventory_posting.stock_rec_qty = item_qty 
      inventory_posting.stock_rec_price = item_price
      inventory_posting.stock_rec_amt = net_amt
      #      inventory_posting.stock_iss_qty = inventory_postings_arr[0].item_qty 
      #      inventory_posting.stock_iss_price = item_price
      #      inventory_posting.stock_iss_amt = net_amt
      inventory_posting.receipt_issue_flag = 'R'
      
      inventory_posting
    end
    
    #for contractor memo create postings
    
    def create_inventory_posting_for_contractor_memo(object)
      inventory_postings = []
      account_period_code = object.account_period_code
      trans_type = 'V'
      trans_type_id = object.contractor_id
      ext_ref_no = object.ext_ref_no
      ext_ref_date = object.ext_ref_date
      catalog_item_id = object.catalog_item_id
      catalog_item_packet_id = nulltozero(object.catalog_item_packet_id)
      item_qty = object.memo_qty
      item_price = object.item_amt/object.memo_qty if object.memo_qty
      net_amt = object.item_amt
      trans_bk = object.trans_bk
      trans_no = object.trans_no
      company_id = object.company_id
      trans_date = object.trans_date
      serial_no = '101'
      trans_flag = object.trans_flag
      inventory_posting = fill_inventory_posting_for_contractor_memo(account_period_code, catalog_item_id, catalog_item_packet_id, 
        item_qty, item_price, net_amt, trans_bk, trans_no,company_id,trans_date,serial_no,trans_type,trans_type_id,ext_ref_no,ext_ref_date,trans_flag)
      inventory_postings << inventory_posting
      inventory_postings
    end 

    def fill_inventory_posting_for_contractor_memo(account_period_code, catalog_item_id, catalog_item_packet_id, item_qty, item_price, net_amt, trans_bk, trans_no,company_id,trans_date,serial_no,trans_type,trans_type_id,ext_ref_no,ext_ref_date,trans_flag)
      inventory_posting = Inventory::InventoryPosting.new
      inventory_posting.trans_bk = trans_bk
      inventory_posting.trans_no = trans_no
      inventory_posting.company_id = company_id
      inventory_posting.trans_date = trans_date
      inventory_posting.serial_no = serial_no
      inventory_posting.update_flag = 'V'
      inventory_posting.account_period_code = account_period_code
      inventory_posting.trans_type = trans_type
      inventory_posting.trans_type_id = trans_type_id
      inventory_posting.ext_ref_no = ext_ref_no
      inventory_posting.ext_ref_date = ext_ref_date
      inventory_posting.catalog_item_id = catalog_item_id
      inventory_posting.catalog_item_packet_id = catalog_item_packet_id
      inventory_posting.trans_flag = trans_flag      
      inventory_posting.stock_iss_qty = item_qty 
      inventory_posting.stock_iss_price = item_price
      inventory_posting.stock_iss_amt = net_amt
      inventory_posting.receipt_issue_flag = 'I'
      inventory_posting
    end

    private :fill_inventory_posting, :identify_post_lines
  end
end  
