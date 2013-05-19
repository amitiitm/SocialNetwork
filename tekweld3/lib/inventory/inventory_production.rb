module Inventory::InventoryProduction

  class Posting
    include General
    include ClassMethods
    def create_inventory_postings(object)
      memo_flag, ri_flag = identify_memo_ri_flags(object)
      curr_lines = identify_post_lines(object)
      inventory_postings = []
      curr_lines.each{|curr_line|
        account_period_code = curr_line.account_period_code
        trans_type = 'L'
        trans_type_id = object.lab_id
        ext_ref_no = object.ext_ref_no
        ext_ref_date = object.ext_ref_date
        catalog_item_id = curr_line.catalog_item_id
        catalog_item_packet_id = nulltozero(curr_line.catalog_item_packet_id)
        item_qty = curr_line.item_qty
        item_price = curr_line.item_price
        net_amt = curr_line.net_amt
        trans_bk = curr_line.trans_bk
        trans_no = curr_line.trans_no
        company_id = curr_line.company_id
        trans_date = curr_line.trans_date
        serial_no = curr_line.serial_no
        inventory_posting = fill_inventory_posting(ri_flag, memo_flag, account_period_code, catalog_item_id, catalog_item_packet_id,
                                                  item_qty, item_price, net_amt, trans_bk, trans_no,company_id,trans_date,serial_no,trans_type,trans_type_id,ext_ref_no,ext_ref_date)
        inventory_postings << inventory_posting
      }
      inventory_postings
    end 

    def fill_inventory_posting(ri_flag, memo_flag, account_period_code, catalog_item_id,catalog_item_packet_id,item_qty, item_price, net_amt, trans_bk, trans_no,company_id,trans_date,serial_no,trans_type,trans_type_id,ext_ref_no,ext_ref_date)
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
      if memo_flag == INVN_MEMO_YES
        case ri_flag
        when INVN_ISSUE
          inventory_posting.memo_iss_qty = item_qty 
          inventory_posting.memo_iss_price = item_price
          inventory_posting.memo_iss_amt = net_amt
        when INVN_RECEIVE
          inventory_posting.memo_rec_qty = item_qty 
          inventory_posting.memo_rec_price = item_price
          inventory_posting.memo_rec_amt = net_amt
        end
      else
        case ri_flag
        when  INVN_TRANSFER
          inventory_posting.memo_rec_qty = item_qty  
          inventory_posting.memo_rec_price = item_price
          inventory_posting.memo_rec_amt = net_amt
          inventory_posting.stock_iss_qty = item_qty  
          inventory_posting.stock_iss_price = item_price
          inventory_posting.stock_iss_amt = net_amt
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

    def identify_memo_ri_flags(object)
      memo_flag = INVN_MEMO_NO ;  ri_flag=INVN_RECEIVE
      case object.class.name
      when 'Sales::SalesInvoice'
        memo_flag = INVN_MEMO_NO
        memo?(object.trans_type)? ri_flag = INVN_TRANSFER : ri_flag = INVN_ISSUE
      when 'Sales::SalesMemo'
        memo_flag = INVN_MEMO_YES ; ri_flag = INVN_ISSUE
      when 'Sales::SalesCreditInvoice'
        memo_flag = INVN_MEMO_NO ;  ri_flag = INVN_RECEIVE
      when 'Sales::SalesMemoReturn'
        memo_flag = INVN_MEMO_YES ; ri_flag = INVN_RECEIVE
        #Newly added for POS
        when 'PointOfSale::PosInvoice'
        memo_flag = INVN_MEMO_NO
        ri_flag = INVN_ISSUE
        when 'Production::LabMemo'
        memo_flag = INVN_MEMO_YES ; ri_flag = INVN_ISSUE
         when 'Production::LabMemoReturn'
        memo_flag = INVN_MEMO_YES ; ri_flag = INVN_RECEIVE
      else
      end
      return memo_flag, ri_flag
    end

    def identify_post_lines(object)
      case object.class.name
      when 'Sales::SalesInvoice'
        object_lines = object.sales_invoice_lines
      when 'Sales::SalesMemo'
        object_lines = object.sales_memo_lines
      when 'Sales::SalesCreditInvoice'
        object_lines = object.sales_credit_invoice_lines
      when 'Sales::SalesMemoReturn'
        object_lines = object.sales_memo_return_lines
        #Newly added for POS
        when 'PointOfSale::PosInvoice'
        object_lines = object.pos_invoice_lines
         when 'Production::LabMemo'
        object_lines = object.lab_memo_lines
        when 'Production::LabMemoReturn'
        object_lines = object.lab_memo_return_lines
      else
      end
      return object_lines
    end

    private :fill_inventory_posting, :identify_memo_ri_flags, :identify_post_lines
  end
end  
