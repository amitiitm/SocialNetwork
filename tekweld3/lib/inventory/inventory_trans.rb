module Inventory::InventoryTrans

  class Posting
    include General
    include ClassMethods
    def create_inventory_postings(object)
      curr_lines = object.inventory_transaction_lines
      inventory_postings = []
      curr_lines.each{|curr_line|
        account_period_code = curr_line.account_period_code
        catalog_item_id = curr_line.catalog_item_id
        catalog_item_packet_id = nulltozero(curr_line.catalog_item_packet_id)
        trans_bk = curr_line.trans_bk
        trans_no = curr_line.trans_no
        company_id = curr_line.company_id
        trans_date = curr_line.trans_date
        serial_no = curr_line.serial_no
        trans_type = object.trans_type
        trans_type_id = object.trans_type_id
        ext_ref_no = object.ext_ref_no
        ext_ref_date = object.ext_ref_date
        #Added by Minal
        catalog_item_code = curr_line.catalog_item_code
        catalog_item_packet_code = curr_line.catalog_item_packet_code
        item_description = curr_line.item_description
        trans_flag = curr_line.trans_flag
        case curr_line.receipt_issue_flag
        when 'I'
          item_qty = curr_line.iss_qty
          item_price = curr_line.iss_price
          net_amt = curr_line.iss_amt
        when 'R'
          item_qty = curr_line.rec_qty
          item_price = curr_line.rec_price
          net_amt = curr_line.rec_amt
        end
        inventory_posting = fill_inventory_posting(curr_line.receipt_issue_flag, INVN_MEMO_NO, account_period_code, catalog_item_id, catalog_item_packet_id, 
                                                  item_qty, item_price, net_amt, trans_bk, trans_no,company_id,trans_date,serial_no,trans_type,trans_type_id,ext_ref_no,ext_ref_date,catalog_item_code,catalog_item_packet_code,item_description,trans_flag)
        inventory_postings << inventory_posting
      }
      inventory_postings
    end 

    def fill_inventory_posting(ri_flag, memo_flag, account_period_code, catalog_item_id, catalog_item_packet_id, item_qty, item_price, net_amt, trans_bk, trans_no,company_id,trans_date,serial_no,trans_type,trans_type_id,ext_ref_no,ext_ref_date,catalog_item_code,catalog_item_packet_code,item_description,trans_flag )
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
      inventory_posting.receipt_issue_flag = ri_flag
      #added by Minal
      inventory_posting.catalog_item_code = catalog_item_code
      inventory_posting.catalog_item_packet_code = catalog_item_packet_code
      inventory_posting.item_description = item_description
      inventory_posting.trans_flag = trans_flag
      if memo_flag == INVN_MEMO_YES
      else
        case ri_flag
        when INVN_ISSUE
          inventory_posting.stock_iss_qty = item_qty 
          inventory_posting.stock_iss_price = item_price
          inventory_posting.stock_iss_amt = net_amt
        when INVN_RECEIVE
          inventory_posting.stock_rec_qty = item_qty
          inventory_posting.stock_rec_price = item_price
          inventory_posting.stock_rec_amt = net_amt
        end
      end
      inventory_posting
    end

    private :fill_inventory_posting
  end
end  
